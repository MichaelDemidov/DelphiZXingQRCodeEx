unit QR_URL;

// URL international encoder class for TDelphiZXingQRCode
// © Michael Demidov, 2014
// http://mik-demidov.blogspot.ru

// NB! Do not use this encoder for non-latin national-level domains,
// they have their own encoding system

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
  Windows, SysUtils;

function HTTPEncode(const AStr: WideString): WideString;
//based on http://marc.durdin.net/2012/07/indy-tiduri-pathencode-urlencode-and-paramsencode-and-more/
const
  HexMap: WideString = '0123456789ABCDEF';

  function IsSafeChar(ch: Integer): Boolean;
  begin
    Result := ch in [Ord('0')..Ord('9'), Ord('A')..Ord('Z'), Ord('a')..Ord('z'),
      Ord('!'), Ord('('), Ord(')'), Ord('*'), Ord('-'), Ord('.'), Ord('_'),
      Ord('~'), Ord(''''), Ord('@'), Ord('#'), Ord('$'), Ord('&'), Ord('='),
      Ord(':'), Ord('/'), Ord(','), Ord(';'), Ord('?'), Ord('+')];
  end;

var
  I, J: Integer;
  S, Z, P: WideString;
  ASrcUTF8: UTF8String;
begin
  S := AStr;
  P := Copy(S, 1, Pos(WideString('://'), S));
  Delete(S, 1, Length(P));

  Z := '';
  ASrcUTF8 := UTF8Encode(S);
  // UTF8Encode call not strictly necessary but
  // prevents implicit conversion warning
 
  I := 1;
  J := 1;
  SetLength(Z, Length(ASrcUTF8) * 3); // space to %xx encode every byte
{$WARNINGS OFF} // turn off "Unsafe code 'String index to var param'"
// warnings. SetLength above guarantees that the string is long enough
  while I <= Length(ASrcUTF8) do
  begin
    if IsSafeChar(Ord(ASrcUTF8[I])) then
    begin
      Z[J] := WideChar(ASrcUTF8[I]);
      Inc(J);
    end
    else
      if ASrcUTF8[I] = ' ' then
      begin
        Z[J] := '+';
        Inc(J);
      end
      else
      begin
        Z[J] := '%';
        Z[J+1] := HexMap[(Ord(ASrcUTF8[I]) shr 4) + 1];
        Z[J+2] := HexMap[(Ord(ASrcUTF8[I]) and 15) + 1];
        Inc(J,3);
      end;
    Inc(I);
  end;
{$WARNINGS ON}
  SetLength(Z, J - 1);
  Result := P + Z;
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
