unit QRGraphics;

// QR Drawing unit for TDelphiZXingQRCode class
// © Michael Demidov, 2014
// http://mik-demidov.blogspot.ru

interface

uses
  Windows, Graphics, DelphiZXingQRCode;

// Add an unit with TMetafile class to make it compatible with the Lazarus.
// E.g. there is \lazarus\components\tachart\TADrawerWMF.pas unit in the Lazarus 1.2.6
// Then find the MakeMetafile() procedure below and delete the line labeled with
// a comment. It's all

type
  TQRDrawingMode = (drwBitmap, drwRectangles, drwRegion);

{--- QR code main drawing procedure ---

* ACanvas is the drawing canvas:
  - ACanvas.Brush is the background ("white" dots),
  - ACanvas.Pen.Color is the foreground ("black" dots) color
* ARect - bounding rectangle
* QRCode is the TDelphiZXingQRCode object representing QR code
* CornerThickness is the thickness of two perpendicular lines in the lower
  right corner
* QRDrawingMode specifies one of these possible modes:
  1) drwBitmap ("bitmap" mode) creates a bitmap wherein each pixel corresponds
     to a dot of the QR matrix and then scales it to given size
  2) drwRectangles ("rectangles" vector mode) makes a set of narrow horizontal
     rectangles ("strips") that represent rows of adjacent dots
  3) drwRegion ("region" vector mode) creates one complex polygonal region
     from these rectangles
* Proportional - if True then the entire image is scaled to square shape and
  centered inside ARect rectangle

NB! In both of the vector modes the dots have the same width and the same
    height regardless of the Proportional parameter's value
}
procedure DrawQR(ACanvas: TCanvas; ARect: TRect; QRCode: TDelphiZXingQRCode;
  CornerThickness: Integer = 0; QRDrawingMode: TQRDrawingMode = drwRegion;
  Proportional: Boolean = True);

{--- create bitmap from QR code ---

* Bitmap is a TBitmap object to draw in
* Scale is a size of image points (squares)
* QRCode is a TDelphiZXingQRCode object representing QR code
* BColor is the background ("white" dots),
* FColor is the foreground ("black" dots) color
* CornerThickness is the thickness of two perpendicular lines in the lower right
  corner of the image

See also demo application for an example of saving in JPEG format. There's nothing
sophisticated, so I didn't add it here
}
procedure MakeBmp(Bitmap: TBitmap; Scale: Integer;
  QRCode: TDelphiZXingQRCode; BColor, FColor: TColor;
  CornerThickness: Integer = 0);

{--- create metafile from QR code ---

* Metafile is a TMetafile object to draw in
* Scale is a size of image points (squares)
* QRCode is a TDelphiZXingQRCode object representing QR code
* BColor is the background ("white" dots),
* FColor is the foreground ("black" dots) color
* QRDrawingMode is the type of metafile content
* CornerThickness is the thickness of two perpendicular lines in the lower right
  corner
}
procedure MakeMetafile(Metafile: TMetafile; Scale: Integer;
  QRCode: TDelphiZXingQRCode; BColor, FColor: TColor;
  QRDrawingMode: TQRDrawingMode = drwRegion; CornerThickness: Integer = 0);

implementation

uses
  Classes;

procedure MakeBmp(Bitmap: TBitmap; Scale: Integer;
  QRCode: TDelphiZXingQRCode; BColor, FColor: TColor;
  CornerThickness: Integer = 0);
begin
  with Bitmap do
  begin
{$IFNDEF FPC}
    // there is the well-known bug in Lazarus: TBitmap.SaveToFile raises
    // an exception ("image palette is too big or absent") when
    // Monochrome = True
    if (BColor = clWhite) and (FColor = clBlack) then
      Monochrome := True;
{$ENDIF}
    Width := QRCode.Columns * Scale + CornerThickness * 2;
    Height := QRCode.Rows * Scale + CornerThickness * 2;
    Canvas.Brush.Color := BColor;
    Canvas.Pen.Color := FColor;
    DrawQR(Canvas, Rect(0, 0, Width, Height), QRCode, CornerThickness);
  end;
end;

procedure MakeMetafile(Metafile: TMetafile; Scale: Integer;
  QRCode: TDelphiZXingQRCode; BColor, FColor: TColor;
  QRDrawingMode: TQRDrawingMode = drwRegion; CornerThickness: Integer = 0);
var
  M: TMetafileCanvas;
  W, H: Integer;
begin
  M := nil;
  W := QRCode.Columns * Scale + CornerThickness * 2;
  H := QRCode.Rows * Scale + CornerThickness * 2;
  with Metafile do
  try
// delete the line below to make it compatible with TADrawerWMF.pas (Lazarus):
    Enhanced := True;

    Width := W;
    Height := H;
    M := TMetafileCanvas.Create(Metafile, 0);
    M.Brush.Color := BColor;
    M.Pen.Color := FColor;
    if QRDrawingMode = drwBitmap then
      QRDrawingMode := drwRectangles;
    DrawQR(M, Rect(0, 0, W, H), QRCode, CornerThickness, QRDrawingMode);
    M.Free;
  except
    M.Free;
    raise
  end;
end;

procedure DrawQR(ACanvas: TCanvas; ARect: TRect; QRCode: TDelphiZXingQRCode;
  CornerThickness: Integer = 0; QRDrawingMode: TQRDrawingMode = drwRegion;
  Proportional: Boolean = True);
var
  W, H, Row, Column, S1, S2: Integer;
  Bmp: TBitmap;
  OldBrush: TBrush;
  R, R1: TRect;
  BigRgn: HRgn;

  procedure AddRect(R: TRect);
  var
    RectRgn: HRgn;
  begin
    RectRgn := CreateRectRgnIndirect(R1);
    if BigRgn = 0 then
      BigRgn := RectRgn
    else
    begin
      CombineRgn(BigRgn, BigRgn, RectRgn, RGN_OR);
      DeleteObject(RectRgn)
    end
  end;

begin
  OldBrush := ACanvas.Brush;
  ACanvas.FillRect(ARect);
  W := ARect.Right - ARect.Left;
  H := ARect.Bottom - ARect.Top;
  if Proportional then
  begin
    if W > H then
    begin
      InflateRect(ARect, (H - W) div 2, 0);
      ARect.Right := ARect.Right - Ord(Odd(W - H))
    end
    else
      if H > W then
      begin
        InflateRect(ARect, 0, (W - H) div 2);
        ARect.Bottom := ARect.Bottom - Ord(Odd(H - W))
      end
  end;
  if CornerThickness > 0 then
    InflateRect(ARect, -CornerThickness, -CornerThickness);
  W := ARect.Right - ARect.Left;
  H := ARect.Bottom - ARect.Top;
  if QRDrawingMode = drwBitmap then
  // PIXELS / RASTER MODE (for bitmaps)
  begin
    Bmp := TBitmap.Create;
    with Bmp do
    try
      if (ACanvas.Brush.Color = clWhite) and
        (ACanvas.Brush.Style = bsSolid) and
        (ACanvas.Pen.Color = clBlack) and
        (ACanvas.Pen.Mode = pmCopy) then
        Monochrome := True;
      Width := QRCode.Columns;
      Height := QRCode.Rows;
      for Row := 0 to QRCode.Rows - 1 do
        for Column := 0 to QRCode.Columns - 1 do
          if QRCode[Row, Column] then
            Canvas.Pixels[Column, Row] := ACanvas.Pen.Color
          else
            Canvas.Pixels[Column, Row] := ACanvas.Brush.Color;
      if (Width > 0) and (Height > 0) then
        ACanvas.StretchDraw(ARect, Bmp);
    finally
      Bmp.Free;
    end;
  end
  else
  // RECTANGLES / VECTOR MODE (for metafiles)
  begin
    BigRgn := 0;

    S1 := W mod QRCode.Columns;
    S2 := H mod QRCode.Rows;
    InflateRect(ARect, -S1 div 2, -S2 div 2);
    ARect.Right := ARect.Right - Ord(Odd(S1));
    ARect.Bottom := ARect.Bottom - Ord(Odd(S2));
    S1 := W div QRCode.Columns;
    S2 := H div QRCode.Rows;
    R := Rect(ARect.Left, ARect.Top, ARect.Left + S1, ARect.Top + S2);
    with ACanvas do
    begin
      Brush.Color := Pen.Color;
      Brush.Style := bsSolid;
      for Row := 0 to QRCode.Rows - 1 do
      begin
        R1 := Rect(R.Left, R.Top, R.Left, R.Bottom);
        for Column := 0 to QRCode.Columns - 1 do
        begin
          if QRCode[Row, Column] then
            R1.Right := R.Right
          else
          begin
            if R1.Right > R1.Left then
              if QRDrawingMode = drwRegion then
                AddRect(R1)
              else
                FillRect(R1);
            R1 := Rect(R.Right, R.Top, R.Right, R.Bottom);
          end;
          OffsetRect(R, S1, 0);
        end;
        if R1.Right > R1.Left then
          if QRDrawingMode = drwRegion then
            AddRect(R1)
          else
            FillRect(R1);
        OffsetRect(R, ARect.Left - R.Left, S2);
      end;
      if QRDrawingMode = drwRegion then
      begin
        FillRgn(Handle, BigRgn, Brush.Handle);
        DeleteObject(BigRgn);
      end;
      if CornerThickness <= 0 then
        Brush.Assign(OldBrush);
    end
  end;
  W := ARect.Right - ARect.Left;
  H := ARect.Bottom - ARect.Top;
  if CornerThickness > 0 then
    with ACanvas do
    begin
      Brush.Color := Pen.Color;
      Brush.Style := bsSolid;
      FillRect(Rect(ARect.Right, ARect.Top + H div 2, ARect.Right +
        CornerThickness, ARect.Bottom));
      FillRect(Rect(ARect.Left + W div 2, ARect.Bottom, ARect.Right +
        CornerThickness, ARect.Bottom + CornerThickness));
      Brush.Assign(OldBrush);
    end;
end;

end.
