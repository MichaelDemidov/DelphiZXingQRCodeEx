object frmMain: TfrmMain
  Left = 549
  Top = 353
  Width = 571
  Height = 500
  Caption = 'Delphi port of ZXing QRCode'
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 550
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object splTop: TSplitter
    Left = 0
    Top = 126
    Width = 563
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 563
    Height = 126
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    FullRepaint = False
    ParentBackground = True
    ParentColor = True
    TabOrder = 0
    object lblText: TLabel
      Left = 8
      Top = 8
      Width = 547
      Height = 13
      Align = alTop
      Caption = '&Text'
      FocusControl = mmoText
      Transparent = True
    end
    object mmoText: TMemo
      Left = 8
      Top = 21
      Width = 547
      Height = 97
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = mmoTextChange
    end
  end
  object pnlDetails: TPanel
    Left = 0
    Top = 131
    Width = 563
    Height = 338
    Align = alBottom
    BevelOuter = bvNone
    FullRepaint = False
    ParentBackground = True
    ParentColor = True
    TabOrder = 1
    object lblEncoding: TLabel
      Left = 8
      Top = 5
      Width = 43
      Height = 13
      Caption = '&Encoding'
      FocusControl = cmbEncoding
      Transparent = True
    end
    object lblQuietZone: TLabel
      Left = 8
      Top = 61
      Width = 52
      Height = 13
      Caption = '&Quiet zone'
      FocusControl = edtQuietZone
      Transparent = True
    end
    object lblErrorCorrectionLevel: TLabel
      Left = 128
      Top = 61
      Width = 100
      Height = 13
      Caption = 'Error &correction level'
      FocusControl = cbbErrorCorrectionLevel
      Transparent = True
    end
    object lblCorner: TLabel
      Left = 8
      Top = 176
      Width = 137
      Height = 13
      Caption = 'Corner &line thickness (pixels)'
      FocusControl = edtCornerThickness
      Transparent = True
    end
    object lblDrawingMode: TLabel
      Left = 8
      Top = 117
      Width = 68
      Height = 13
      Caption = '&Drawing mode'
      FocusControl = cbbDrawingMode
      Transparent = True
    end
    object cmbEncoding: TComboBox
      Left = 8
      Top = 24
      Width = 265
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cmbEncodingChange
      OnDrawItem = cmbEncodingDrawItem
      OnMeasureItem = cmbEncodingMeasureItem
      Items.Strings = (
        'Auto'
        'Numeric'
        'Alphanumeric'
        'ISO-8859-1'
        'UTF-8 without BOM'
        'UTF-8 with BOM'
        'URL encoding'
        'Windows-1251')
    end
    object edtQuietZone: TEdit
      Left = 8
      Top = 80
      Width = 73
      Height = 21
      TabOrder = 2
      Text = '4'
      OnChange = edtQuietZoneChange
    end
    object cbbErrorCorrectionLevel: TComboBox
      Left = 128
      Top = 80
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = cbbErrorCorrectionLevelChange
      Items.Strings = (
        'L ~7% correction'
        'M ~15% correction'
        'Q ~25% correction'
        'H ~30% correction')
    end
    object edtCornerThickness: TEdit
      Left = 168
      Top = 172
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '0'
      OnChange = edtCornerThicknessChange
    end
    object udCornerThickness: TUpDown
      Left = 217
      Top = 172
      Width = 16
      Height = 21
      Associate = edtCornerThickness
      TabOrder = 7
    end
    object udQuietZone: TUpDown
      Left = 81
      Top = 80
      Width = 16
      Height = 21
      Associate = edtQuietZone
      Position = 4
      TabOrder = 3
    end
    object grpSaveToFile: TGroupBox
      Left = 8
      Top = 208
      Width = 265
      Height = 121
      Caption = '&Save / Copy'
      TabOrder = 8
      object lblScaleToSave: TLabel
        Left = 8
        Top = 24
        Width = 76
        Height = 13
        Caption = 'Dot size (pixels)'
        FocusControl = edtScaleToSave
        Transparent = True
      end
      object edtFileName: TEdit
        Left = 8
        Top = 56
        Width = 193
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object btnSaveToFile: TButton
        Left = 200
        Top = 56
        Width = 51
        Height = 21
        Caption = 'Save...'
        TabOrder = 3
        OnClick = btnSaveToFileClick
      end
      object edtScaleToSave: TEdit
        Left = 112
        Top = 20
        Width = 49
        Height = 21
        TabOrder = 0
        Text = '10'
      end
      object udScaleToSave: TUpDown
        Left = 161
        Top = 20
        Width = 16
        Height = 21
        Associate = edtScaleToSave
        Min = 1
        Position = 10
        TabOrder = 1
      end
      object btnCopy: TButton
        Left = 8
        Top = 88
        Width = 249
        Height = 25
        Caption = 'C&opy Bitmap to Clipboard'
        TabOrder = 4
        OnClick = btnCopyClick
      end
    end
    object cbbDrawingMode: TComboBox
      Left = 8
      Top = 136
      Width = 265
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
      OnChange = cbbDrawingModeChange
      Items.Strings = (
        'Bitmap proportional'
        'Bitmap non-proportional'
        'Vector: rectangles proportional'
        'Vector: rectangles non-proportional'
        'Vector: region proportional'
        'Vector: region non-proportional')
    end
    object pgcQRDetails: TPageControl
      Left = 296
      Top = 5
      Width = 233
      Height = 289
      ActivePage = tsPreview
      TabOrder = 0
      object tsPreview: TTabSheet
        Caption = '&Preview'
        object pbPreview: TPaintBox
          Left = 0
          Top = 0
          Width = 225
          Height = 187
          Align = alClient
          OnPaint = pbPreviewPaint
        end
        object lblQRMetrics: TLabel
          Left = 0
          Top = 187
          Width = 225
          Height = 13
          Align = alBottom
          Alignment = taCenter
          Caption = 'lblQRMetrics'
          Transparent = True
        end
        object pnlColors: TPanel
          Left = 0
          Top = 200
          Width = 225
          Height = 61
          Align = alBottom
          BevelOuter = bvNone
          ParentBackground = True
          ParentColor = True
          TabOrder = 0
          object bvlColors: TBevel
            Left = 0
            Top = 0
            Width = 225
            Height = 9
            Align = alTop
            Shape = bsBottomLine
          end
          object lblBackground: TLabel
            Left = 8
            Top = 16
            Width = 56
            Height = 13
            Caption = '&Background'
            FocusControl = clrbxBackground
          end
          object lblForeground: TLabel
            Left = 8
            Top = 40
            Width = 56
            Height = 13
            Caption = '&Foreground'
            FocusControl = clrbxForeground
          end
          object clrbxBackground: TColorBox
            Left = 80
            Top = 11
            Width = 137
            Height = 22
            DefaultColorColor = clWhite
            Selected = clWhite
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
            OnChange = clrbxBackgroundChange
          end
          object clrbxForeground: TColorBox
            Left = 80
            Top = 35
            Width = 137
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 1
            OnChange = clrbxForegroundChange
          end
        end
      end
      object tsEncodedData: TTabSheet
        Caption = 'E&ncoded Data'
        ImageIndex = 1
        object mmoEncodedData: TMemo
          Left = 0
          Top = 0
          Width = 225
          Height = 261
          Align = alClient
          BorderStyle = bsNone
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = mmoTextChange
        end
      end
    end
  end
  object dlgSaveToFile: TSaveDialog
    Filter = 
      'Bitmap (*.bmp)|*.bmp|Metfile (*.emf)|*.emf|JPEG (*.jpeg; *.jpg)|' +
      '*.jpeg;*.jpg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 328
    Top = 288
  end
end
