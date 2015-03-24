unit DelphiZXingQRCodeTestAppMainForm;

// Demo app for ZXing QRCode port to Delphi
// © Debenu Pty Ltd
// www.debenu.com

// Modifications (well, almost complete remake)
// © Michael Demidov, 2014
// http://mik-demidov.blogspot.ru/ (in Russian)
// e-mail: michael.v.demidov@gmail.com

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DelphiZXingQRCode, ExtCtrls, ComCtrls, StdCtrls;

type
  TfrmMain = class(TForm)
    mmoText: TMemo;
    lblText: TLabel;
    cmbEncoding: TComboBox;
    lblEncoding: TLabel;
    lblQuietZone: TLabel;
    edtQuietZone: TEdit;
    cbbErrorCorrectionLevel: TComboBox;
    lblErrorCorrectionLevel: TLabel;
    edtCornerThickness: TEdit;
    udCornerThickness: TUpDown;
    lblCorner: TLabel;
    udQuietZone: TUpDown;
    grpSaveToFile: TGroupBox;
    dlgSaveToFile: TSaveDialog;
    edtFileName: TEdit;
    lblScaleToSave: TLabel;
    edtScaleToSave: TEdit;
    udScaleToSave: TUpDown;
    lblDrawingMode: TLabel;
    cbbDrawingMode: TComboBox;
    pnlDetails: TPanel;
    pnlTop: TPanel;
    splTop: TSplitter;
    pgcQRDetails: TPageControl;
    tsPreview: TTabSheet;
    pbPreview: TPaintBox;
    tsEncodedData: TTabSheet;
    mmoEncodedData: TMemo;
    lblQRMetrics: TLabel;
    btnSaveToFile: TButton;
    pnlColors: TPanel;
    clrbxBackground: TColorBox;
    lblBackground: TLabel;
    lblForeground: TLabel;
    clrbxForeground: TColorBox;
    bvlColors: TBevel;
    btnCopy: TButton;
    procedure FormCreate(Sender: TObject);
    procedure mmoTextChange(Sender: TObject);
    procedure cmbEncodingChange(Sender: TObject);
    procedure edtQuietZoneChange(Sender: TObject);
    procedure cbbErrorCorrectionLevelChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbbDrawingMethodChange(Sender: TObject);
    procedure edtCornerThicknessChange(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure cbbDrawingModeChange(Sender: TObject);
    procedure cmbEncodingMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure cmbEncodingDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pbPreviewPaint(Sender: TObject);
    procedure clrbxBackgroundChange(Sender: TObject);
    procedure clrbxForegroundChange(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    FQRCode: TDelphiZXingQRCode;
    // to fix well-known Delphi 7 error with visually vanishing components
    // under Windows Vista, 7, and later
    FAltFixed: Boolean;
    procedure RemakeQR;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  QRGraphics, QR_Win1251, QR_URL, jpeg, Clipbrd;

{$R *.dfm}

procedure TfrmMain.cmbEncodingChange(Sender: TObject);
begin
  RemakeQR;
  mmoEncodedData.Text := FQRCode.FilteredData;
end;

procedure TfrmMain.edtQuietZoneChange(Sender: TObject);
begin
  RemakeQR;
end;

procedure TfrmMain.mmoTextChange(Sender: TObject);
begin
  RemakeQR;
  mmoEncodedData.Text := FQRCode.FilteredData;
end;

procedure TfrmMain.cbbErrorCorrectionLevelChange(Sender: TObject);
begin
  RemakeQR;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  H: Integer;
begin
  FAltFixed := False;
  FQRCode := nil;

  // number edit
  SetWindowLong(edtQuietZone.Handle, GWL_STYLE,
    GetWindowLong(edtQuietZone.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(edtCornerThickness.Handle, GWL_STYLE,
    GetWindowLong(edtCornerThickness.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(edtScaleToSave.Handle, GWL_STYLE,
    GetWindowLong(edtScaleToSave.Handle, GWL_STYLE) or ES_NUMBER);

  // controls size and position
  lblText.AutoSize := False;
  lblText.Height := cmbEncoding.Top - lblEncoding.Top;
  pnlTop.Constraints.MinHeight := lblText.Height + pnlTop.BorderWidth * 2 +
    cmbEncoding.Height;
  splTop.MinSize := pnlTop.Constraints.MinHeight;
  pnlDetails.Constraints.MinHeight := grpSaveToFile.BoundsRect.Bottom +
    grpSaveToFile.Left;
  pnlDetails.Constraints.MinWidth := pgcQRDetails.BoundsRect.Right +
    mmoText.Left + Width - ClientWidth;
  ClientHeight := pnlDetails.Constraints.MinHeight +
    pnlTop.Constraints.MinHeight + splTop.Height + 4;
  Constraints.MinHeight := Height;
  pgcQRDetails.Width := pnlDetails.ClientWidth - mmoText.Left -
    pgcQRDetails.Left;
  pgcQRDetails.Height := pnlDetails.ClientHeight - pgcQRDetails.Top -
    mmoText.Left;
  pgcQRDetails.Anchors := AnchorAlign[alClient];
  lblBackground.Left := lblEncoding.Left;
  lblForeground.Left := lblEncoding.Left;
  bvlColors.Height := lblEncoding.Top + 2;
  clrbxBackground.Top := lblEncoding.Top + bvlColors.Height;
  clrbxBackground.Width := pnlColors.ClientWidth - clrbxBackground.Left -
    clrbxBackground.Top;
  clrbxBackground.Anchors := AnchorAlign[alTop];
  clrbxForeground.Width := clrbxBackground.Width;
  clrbxForeground.Anchors := clrbxBackground.Anchors;
  lblBackground.Top := clrbxBackground.Top + (clrbxBackground.Height -
    lblBackground.Height) div 2;
  clrbxForeground.Top := clrbxBackground.BoundsRect.Bottom + lblEncoding.Top;
  lblForeground.Top := clrbxForeground.Top + (clrbxForeground.Height -
    lblForeground.Height) div 2;
  pnlColors.ClientHeight := clrbxForeground.BoundsRect.Bottom + lblEncoding.Top;
  mmoText.Width := ClientWidth - mmoText.Left * 2 + bvlColors.Height;
  Height := Height + mmoText.Height;

  Position := poScreenCenter;
  with cmbEncoding do
  begin
    H := ItemHeight;
    Style := csOwnerDrawVariable;
    ItemHeight := H;
    OnChange := nil;
    ItemIndex := 0;
    OnChange := cmbEncodingChange
  end;
  with cbbErrorCorrectionLevel do
  begin
    OnChange := nil;
    ItemIndex := 0;
    OnChange := cbbErrorCorrectionLevelChange
  end;
  with cbbDrawingMode do
  begin
    OnChange := nil;
    ItemIndex := 0;
    OnChange := cbbDrawingModeChange
  end;
  // create and prepare QRCode component
  FQRCode := TDelphiZXingQRCode.Create;
  FQRCode.RegisterEncoder(ENCODING_WIN1251, TWin1251Encoder);
  FQRCode.RegisterEncoder(ENCODING_URL, TURLEncoder);

  // get ready!
  mmoText.Text := 'Hello, world';
end;

procedure TfrmMain.RemakeQR;
// QR-code generation
begin
  with FQRCode do
  try
    BeginUpdate;
    Data := mmoText.Text;
    Encoding := cmbEncoding.ItemIndex;
    ErrorCorrectionOrdinal := TErrorCorrectionOrdinal
      (cbbErrorCorrectionLevel.ItemIndex);
    QuietZone := StrToIntDef(edtQuietZone.Text, 4);
    EndUpdate(True);
    lblQRMetrics.Caption := IntToStr(Columns) + 'x' + IntToStr(Rows) + ' (' +
      IntToStr(Columns - QuietZone * 2) + 'x' + IntToStr(Rows - QuietZone * 2) +
      ')';
  finally
    pbPreview.Repaint;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FQRCode.Free
end;

procedure TfrmMain.cbbDrawingMethodChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TfrmMain.edtCornerThicknessChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TfrmMain.btnSaveToFileClick(Sender: TObject);
var
  Bmp: TBitmap;
  M: TMetafile;
  S: string;
  J: TJPEGImage;
begin
  if dlgSaveToFile.Execute then
  begin
    S := LowerCase(ExtractFileExt(dlgSaveToFile.FileName));
    if S = '' then
    begin
      case dlgSaveToFile.FilterIndex of
        0, 1: S := '.bmp';
        2: S := '.emf';
        3: S := '.jpg';
      end;
      dlgSaveToFile.FileName := dlgSaveToFile.FileName + S;
    end;

    edtFileName.Text := dlgSaveToFile.FileName;
    Bmp := nil;
    M := nil;
    J := nil;
    if S = '.bmp' then
    try
      Bmp := TBitmap.Create;
      MakeBmp(Bmp, udScaleToSave.Position, FQRCode, clrbxBackground.Selected,
        clrbxForeground.Selected, udCornerThickness.Position);
      Bmp.SaveToFile(dlgSaveToFile.FileName);
      Bmp.Free;
    except
      Bmp.Free;
      raise;
    end
    else
      if S = '.emf' then
      try
        M := TMetafile.Create;
        MakeMetafile(M, udScaleToSave.Position, FQRCode,
          clrbxBackground.Selected, clrbxForeground.Selected,
          TQRDrawingMode(cbbDrawingMode.ItemIndex div 2),
          udCornerThickness.Position);
        M.SaveToFile(dlgSaveToFile.FileName);
        M.Free;
      except
        M.Free;
        raise;
      end
      else
        if S = '.jpg' then
        try
          Bmp := TBitmap.Create;
          MakeBmp(Bmp, udScaleToSave.Position, FQRCode,
            clrbxBackground.Selected, clrbxForeground.Selected,
            udCornerThickness.Position);
          J := TJPEGImage.Create;
          J.Assign(Bmp);
          J.SaveToFile(dlgSaveToFile.FileName);
          J.Free;
          Bmp.Free;
        except
          J.Free;
          Bmp.Free;
          raise;
        end
  end;
end;

procedure TfrmMain.cbbDrawingModeChange(Sender: TObject);
begin
  dlgSaveToFile.FilterIndex := Ord(TQRDrawingMode(cbbDrawingMode.ItemIndex
    div 2) <> drwBitmap) + 1;
  pbPreview.Repaint
end;

procedure TfrmMain.cmbEncodingMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
begin
  AHeight := cmbEncoding.ItemHeight;
  if Index in [0, ENCODING_UTF8_BOM + 1] then
    AHeight := AHeight * 2;
end;

procedure TfrmMain.cmbEncodingDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  R1, R2: TRect;
  IsSpecialLine: Boolean;
  OldColor, OldFontColor: TColor;
  S: string;
begin
  IsSpecialLine := (Index in [0, ENCODING_UTF8_BOM + 1]) and
    not (odComboBoxEdit in State);
  with Control as TComboBox do
  begin
    if IsSpecialLine then
    begin
      R1 := Rect;
      R2 := R1;
      R1.Bottom := (Rect.Bottom + Rect.Top) div 2;
      R2.Top := R1.Bottom;
    end
    else
      R2 := Rect;
    Canvas.FillRect(R2);
    if Index >= 0 then
    begin
      if IsSpecialLine then
      begin
        OldColor := Canvas.Brush.Color;
        OldFontColor := Canvas.Font.Color;
        Canvas.Brush.Color := clBtnFace;
        Canvas.Font.Style := [fsBold];
        Canvas.Font.Color := clGrayText;
        Canvas.FillRect(R1);
        if Index = 0 then
          S := 'Default'
        else
          S := 'Extended';
        Canvas.TextOut((R1.Left + R1.Right - Canvas.TextWidth(S)) div 2, R1.Top,
          S);
        Canvas.Font.Assign(Font);
        Canvas.Brush.Color := OldColor;
        Canvas.Font.Color := OldFontColor;
      end;
      Canvas.TextOut(R2.Left + 2, R2.Top, Items[Index]);
    end;
    if IsSpecialLine and (odFocused in State) then
      with Canvas do
      begin
        DrawFocusRect(Rect);
        DrawFocusRect(R2);
      end;
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

procedure InvalidateControl(W: TWinControl);
var
  I: Integer;
begin
  with W do
  begin
    for I := 0 to ControlCount - 1 do
      if Controls[I] is TWinControl then
        InvalidateControl(Controls[I] as TWinControl);
    Invalidate;
  end;
end;

begin
  if not FAltFixed and (ssAlt in Shift) then
  begin
    InvalidateControl(Self);
    FAltFixed := True;
  end;
end;

procedure TfrmMain.pbPreviewPaint(Sender: TObject);
begin
  with pbPreview.Canvas do
  begin
    Pen.Color := clrbxForeground.Selected;
    Brush.Color := clrbxBackground.Selected;
  end;
  DrawQR(pbPreview.Canvas, pbPreview.ClientRect, FQRCode,
    udCornerThickness.Position, TQRDrawingMode(cbbDrawingMode.ItemIndex div 2),
    Boolean(1 - cbbDrawingMode.ItemIndex mod 2));
end;

procedure TfrmMain.clrbxBackgroundChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TfrmMain.clrbxForegroundChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TfrmMain.btnCopyClick(Sender: TObject);
var
  Bmp: TBitmap;
begin
  Bmp := nil;
  try
    Bmp := TBitmap.Create;
    MakeBmp(Bmp, udScaleToSave.Position, FQRCode, clrbxBackground.Selected,
      clrbxForeground.Selected, udCornerThickness.Position);
    Clipboard.Assign(Bmp);
    Bmp.Free;
  except
    Bmp.Free;
    raise;
  end;
end;

end.
