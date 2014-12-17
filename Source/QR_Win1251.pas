unit QR_Win1251;

// Win-1251 encoder class for TDelphiZXingQRCode
// © Michael Demidov, 2014
// http://mik-demidov.blogspot.ru

interface

uses
  DelphiZXIngQRCode;

const
  ENCODING_WIN1251 = 7;

type
  TWin1251Encoder = class(TEncoder)
  protected
    function FilterContent(const Content: WideString; Mode: TMode;
      EncodeOptions: Integer): WideString; override;
    procedure AppendBytes(const Content: WideString; Mode: TMode;
      Bits: TBitArray; EncodeOptions: Integer); override;
  end;

implementation

uses
  Windows;

function TWin1251Encoder.FilterContent(const Content: WideString; Mode: TMode;
  EncodeOptions: Integer): WideString;
var
  X: Integer;
  CanAdd: Boolean;

  function Is1251Char(Char: WideChar): Boolean;
  // a little trick: set cannot contain numbers over 255 but UTF-8 encoded
  // Russian characters have codes greater than 1000 and some of them are
  // greater than 8000
  const
    Charset1000 = [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 38, 39, 40,
      41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
      59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76,
      77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94,
      95, 96, 97, 98, 99, 100, 101, 102, 103, 105, 106, 107, 108, 109, 110, 111,
      112, 113, 114, 115, 116, 118, 119, 168, 169];
    Charset8000 = [211, 212, 216, 217, 218, 220, 221, 222, 224, 225, 226, 230,
      240, 249, 250];
    Charset8300 = [64, 170, 182];
  begin
    Result := (Ord(Char) - 1000 in Charset1000) or (Ord(Char) - 8000 in
      Charset8000) or (Ord(Char) - 8300 in Charset8300);
  end;

begin
  if EncodeOptions = ENCODING_WIN1251
  then
  begin
    Result := '';
    for X := 1 to Length(Content) do
    begin
      CanAdd := (Ord(Content[X]) <= $FF) or Is1251Char(Content[X]);
      if CanAdd then
        Result := Result + Content[X];
    end;
  end
  else
    Result := inherited FilterContent(Content, Mode, EncodeOptions)
end;

procedure TWin1251Encoder.AppendBytes(const Content: WideString; Mode: TMode;
   Bits: TBitArray; EncodeOptions: Integer);
var
  I, X: Integer;
  Bytes: TByteArray;
begin
  if EncodeOptions = ENCODING_WIN1251
  then
  begin
{$WARNINGS OFF} // I hate these "Unsafe code @ operator" warnings but I never
// turn them off completely. Sometimes they are really useful
    X := WideCharToMultiByte(1251, WC_COMPOSITECHECK or WC_DISCARDNS or
      WC_SEPCHARS or WC_DEFAULTCHAR, @Content[1], -1, nil, 0, nil, nil);
    SetLength(Bytes, X - 1);
    if X > 1 then
      WideCharToMultiByte(1251, WC_COMPOSITECHECK or WC_DISCARDNS or
        WC_SEPCHARS or WC_DEFAULTCHAR, @Content[1], -1, @Bytes[0], X - 1, nil,
        nil);
{$WARNINGS ON}
    for I := 0 to Length(Bytes) - 1 do
      Bits.AppendBits(Bytes[I], 8);
  end
  else
    inherited AppendBytes(Content, Mode, Bits, EncodeOptions);
end;

end.
 