unit QR_URL;

// URL international encoder class for TDelphiZXingQRCode. Supports IDN
// © Michael Demidov, 2014-2015
// http://mik-demidov.blogspot.com

// GitHub source:
// https://github.com/MichaelDemidov/DelphiZXingQRCodeEx

interface

uses
  DelphiZXIngQRCode;

const
  ENCODING_URL = 6;

type
  TURLEncoder = class(TEncoder)
  protected
    function ChooseMode(const Content: WideString; var EncodeOptions: Integer):
      TMode; override;
    function FilterContent(const Content: WideString; Mode: TMode;
      EncodeOptions: Integer): WideString; override;
  end;

implementation

uses
{$IFDEF MSWINDOWS} // Windows.pas is for MulDiv() function only
  SysUtils, Windows;
{$ELSE}
  SysUtils;

function MulDiv(nNumber, nNumerator, nDenominator: Integer): Integer;
begin
  Result := nNumber * nNumerator div nDenominator;
end;
{$ENDIF}

// zero-based strings workaround
{$IFNDEF DCC} // very old Delphi versions and Lazarus
  {$I StrZero.inc}
{$ELSE}
  {$IFNDEF VER240} // Delphi versions earlier than XE3
    {$I StrZero.inc}
  {$ENDIF}
{$ENDIF}

type
  TURLPart = (urlPrefix, urlDomain, urlTail);
  // urlPrefix is 'http://', 'ftp://', etc., still unchanged
  // urlDomain is between 'http://' (exlusive) and next '/', '?', or '#' (inclusive),
  //      use IDN (punycode)
  // urlTail is anything after first non-prefix '/', use percent-encoding

function IDNEncode(Domain: WideString): WideString;
const
  IDNBase = 36;
  IDNMinDigit = 1;
  IDNMaxDigit = 9;
  IDNMaxLetterDigit = 26;
  IDNSkew = 38;
  IDNDamp = 700;
  IDNStartBias = 72;
  IDNStartValue = $80;
  IDNDelimiter = '-';
  IDNDot = Ord('.');
  IDNPrefix = 'xn--';
var
  B, C, H, I, M, M2, N, L, K, Q, T, Bias, Delta: Integer;
  NeedEncoding: Boolean;

  function IDNCalcBias(Delta, NumPoints: Integer; FirstTime: boolean): Integer;
  var
    K: Integer;
  begin
    if FirstTime then
      Delta := Delta div IDNDamp
    else
      Delta := Delta div 2;
    Delta := Delta + (Delta div NumPoints);
    K := 0;
    while Delta > MulDiv(IDNBase - IDNMinDigit, IDNMaxLetterDigit, 2) do
    begin
      Delta := Delta div (IDNBase - IDNMinDigit);
      Inc(K, IDNBase);
    end;
    Result := K + MulDiv(IDNBase - IDNMinDigit + 1, Delta, Delta + IDNSkew);
  end;

  function IDNEncodeDigit(Value: Integer):Integer;
  begin
    if Value < IDNMaxLetterDigit then
      Result := Value + Ord('a')
    else
      if (Value > IDNMaxLetterDigit - IDNMinDigit) and
          (Value < IDNMaxLetterDigit + IDNMaxDigit + IDNMinDigit) then
        Result := Value + Ord('0') - IDNMaxLetterDigit
      else
        Result := Value + Ord('0') - IDNMaxLetterDigit + 70;
  end;

begin
  L := Low(Domain);
  NeedEncoding := True;
  for I := L to Length(Domain) + 1 - L do
    if Ord(Domain[I]) = IDNDot then
    begin
      Result := IDNEncode(Copy(Domain, 1, I - 1)) + '.' +
        IDNEncode(Copy(Domain, I + 1, MaxInt));
      NeedEncoding := False;
      Break;
    end;

  if NeedEncoding then
  begin
    NeedEncoding := False;
    for I := L to Length(Domain) + 1 - L do
      if Ord(Domain[I]) > IDNStartValue then
      begin
        NeedEncoding := True;
        Break;
      end;
    if NeedEncoding then
    begin
      N := IDNStartValue;
      Bias := IDNStartBias;
      Result := IDNPrefix;
      Delta := 0;
      H := 0;
      B := 0;

      for I := L to Length(Domain) + 1 - L do
        if Ord(Domain[I]) < IDNStartValue then
        begin
          Result := Result + Domain[I];
          Inc(H);
          Inc(B);
        end;

      if B > 0 then
        Result := Result + IDNDelimiter;

      while H < Length(Domain) + L - 1 do
      begin
        M := MaxInt;

        for I := 0 to Length(Domain) - 1 do
        begin
          M2 := Ord(Domain[I + L]);
          if (M2 < M) and (M2 >= N) then
            M := M2;
        end;

        Delta := Delta + (M - N) * (H + 1);
        N := M;
 
        for I := 0 to Length(Domain) - 1 do
        begin
          C := Ord(Domain[I + L]);
          if (C < N) or (C < Ord(IDNStartValue)) then
            Inc(Delta);
          if C = N then
          begin
            Q := Delta;
            K := IDNBase;
            repeat
              if K <= Bias then
                T := IDNMinDigit
              else
                if K >= Bias + IDNMaxLetterDigit then
                  T := IDNMaxLetterDigit
                else
                  T := K - Bias;
              if Q >= T then
              begin
                Result := Result + WideChar(IDNEncodeDigit((T + (Q - T) mod
                  (IDNBase - T))));
                Q := (Q - T) div (IDNBase - T);
                Inc(K, IDNBase);
              end
            until
              Q < T;

            Result := Result + WideChar(IDNEncodeDigit(Q));
            Bias := IDNCalcBias(Delta, H + 1, H = B);
            Delta := 0;
            Inc(H);
          end;
        end;
        Inc(Delta);
        Inc(N);
      end;
      Result := Result;
    end
    else
      Result := Domain
  end;
end;

function HTTPEncode(const AStr: WideString): WideString;
// NB! This function does not check URL structure correctness. The only thing
// it checks is a prefix like 'http:', 'mailto:' and so on (see URLPrefixes
// array below)
const
  URLPrefixCount = 6;
  URLPrefixes: array[0..URLPrefixCount - 1] of WideString = (
    // Just a demo! There are many other prefixes
    'http', 'https', 'ftp', 'sftp', 'ssh', 'mailto');
  HexMap: WideString = '0123456789ABCDEF';
  URLDomainDelimiters = [Ord('/'), Ord('#'), Ord('?')];

  function IsURLSafeChar(ch: Integer): Boolean;
  begin
    Result := ch in [Ord('0')..Ord('9'), Ord('A')..Ord('Z'), Ord('a')..Ord('z'),
      Ord('!'), Ord('('), Ord(')'), Ord('*'), Ord('-'), Ord('.'), Ord('_'),
      Ord('~'), Ord(''''), Ord('@'), Ord('#'), Ord('$'), Ord('&'), Ord('='),
      Ord(':'), Ord('/'), Ord(','), Ord(';'), Ord('?'), Ord('+')];
  end;

var
  Part: TURLPart;
  I, J, L: Integer;
  URLPrefixStates: array[0..URLPrefixCount - 1] of Boolean;
  Domain, Tail: WideString;
  AStrUTF8: UTF8String;
begin
  Part := urlPrefix;
  Result := '';
  L := Low(AStr);
  I := L;
  Tail := '';
  Domain := '';
  for J := System.Low(URLPrefixStates) to High(URLPrefixStates) do
    URLPrefixStates[J] := True;
  while I <= Length(AStr) - 1 + L do
  begin
    case Part of
      urlPrefix:
        if AStr[I] <> ':' then
        begin
          for J := System.Low(URLPrefixStates) to High(URLPrefixStates) do
            URLPrefixStates[J] := URLPrefixStates[J] and
              (I <= Length(URLPrefixes[J]) + L - 1) and
              (URLPrefixes[J][I] = AStr[I]);
          Inc(I);
        end
        else // AStr[I] = ':'
        begin
          for J := System.Low(URLPrefixStates) to High(URLPrefixStates) do
            if URLPrefixStates[J] and (I > Length(URLPrefixes[J]) + L - 1) then
            begin
              Result := URLPrefixes[J];
              Part := urlDomain;
              Break;
            end;
          if Part = urlDomain then
          begin
            Result := Result + AStr[I];
            Inc(I); // skip ':'
            while AStr[I] = '/' do
            begin
              Result := Result + AStr[I];
              Inc(I); // skip all '/'
            end;
          end
          else
          begin
            Result := ''; // unknown prefix = no Result
            Break;
          end;
        end;
      urlDomain:
        if Ord(AStr[I]) in URLDomainDelimiters then
        begin
          Part := urlTail;
          while Ord(AStr[I]) in URLDomainDelimiters do
          begin
            Tail := Tail + AStr[I];
            Inc(I); // skip all '/'
          end;
        end
        else
        begin
          Domain := Domain + AStr[I];
          Inc(I);
        end;
      urlTail:
        begin
          Tail := Tail + AStr[I];
          Inc(I);
        end;
    end;
  end;

  // the domain must be encoded using IDN (punycode) algorythm
  if Domain <> '' then
    Result := Result + IDNEncode(Domain);

  // the tail must be encoded using UTF8-based percent-codes
  if (Result <> '') and (Tail <> '') then
  begin
    AStrUTF8 := UTF8Encode(Tail);
    // UTF8Encode call not strictly necessary but
    // prevents implicit conversion warning
    I := L;
    J := L;
    Tail := '';
    SetLength(Tail, Length(AStrUTF8) * 3); // space to %xx encode every byte
{$IFDEF FPC}
  {$WARNINGS OFF}
{$ELSE}
  {$WARN UNSAFE_CODE OFF} // turn off "Unsafe code 'String index to var param'"
  // warnings. SetLength above guarantees that the string is long enough
{$ENDIF}
    while I <= Length(AStrUTF8) + L - 1 do
    begin
      if IsURLSafeChar(Ord(AStrUTF8[I])) then
      begin
        Tail[J] := WideChar(AStrUTF8[I]);
        Inc(J);
      end
      else
        if AStrUTF8[I] = ' ' then
        begin
          Tail[J] := '+';
          Inc(J);
        end
        else
        begin
          Tail[J] := '%';
          Tail[J + 1] := HexMap[(Ord(AStrUTF8[I]) shr 4) + 1];
          Tail[J + 2] := HexMap[(Ord(AStrUTF8[I]) and 15) + 1];
          Inc(J, 3);
        end;
      Inc(I);
    end;
{$IFDEF FPC}
  {$WARNINGS ON}
{$ELSE}
  {$WARN UNSAFE_CODE ON}
{$ENDIF}
    SetLength(Tail, J - L);
    Result := Result + Tail;
  end;
end;

function TURLEncoder.ChooseMode(const Content: WideString;
  var EncodeOptions: Integer): TMode;
begin
  Result := inherited ChooseMode(HTTPEncode(Content), EncodeOptions);
end;

function TURLEncoder.FilterContent(const Content: WideString; Mode: TMode;
  EncodeOptions: Integer): WideString;
begin
  if EncodeOptions = ENCODING_URL
  then
    Result := HTTPEncode(Content)
  else
    Result := inherited FilterContent(Content, Mode, EncodeOptions)
end;

end.
