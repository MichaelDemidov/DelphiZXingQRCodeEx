object frmMain: TfrmMain
  Left = 431
  Top = 312
  Width = 571
  Height = 441
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
    Top = 98
    Width = 555
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 555
    Height = 98
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
      Width = 539
      Height = 13
      Align = alTop
      Caption = '&Text'
      FocusControl = mmoText
      Transparent = True
    end
    object mmoText: TMemo
      Left = 8
      Top = 21
      Width = 539
      Height = 69
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = mmoTextChange
    end
  end
  object pnlDetails: TPanel
    Left = 0
    Top = 103
    Width = 555
    Height = 300
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
      TabOrder = 0
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
      TabOrder = 1
      Text = '4'
      OnChange = edtQuietZoneChange
    end
    object cbbErrorCorrectionLevel: TComboBox
      Left = 128
      Top = 80
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 3
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
      TabOrder = 4
      Text = '0'
      OnChange = edtCornerThicknessChange
    end
    object udCornerThickness: TUpDown
      Left = 217
      Top = 172
      Width = 16
      Height = 21
      Associate = edtCornerThickness
      TabOrder = 6
    end
    object udQuietZone: TUpDown
      Left = 81
      Top = 80
      Width = 16
      Height = 21
      Associate = edtQuietZone
      Position = 4
      TabOrder = 2
    end
    object grpSaveToFile: TGroupBox
      Left = 8
      Top = 208
      Width = 265
      Height = 97
      Caption = '&Save to file'
      TabOrder = 5
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
    end
    object cbbDrawingMode: TComboBox
      Left = 8
      Top = 136
      Width = 265
      Height = 21
      Style = csDropDownList
      TabOrder = 7
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
      TabOrder = 8
      object tsPreview: TTabSheet
        Caption = '&Preview'
        object pbPreview: TPaintBox
          Left = 0
          Top = 0
          Width = 225
          Height = 248
          Align = alClient
          OnPaint = pbPreviewPaint
        end
        object lblQRMetrics: TLabel
          Left = 0
          Top = 248
          Width = 225
          Height = 13
          Align = alBottom
          Alignment = taCenter
          Caption = 'lblQRMetrics'
          Transparent = True
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
