object frmImportCSV: TfrmImportCSV
  Left = 0
  Top = 0
  Width = 935
  Height = 481
  TabOrder = 0
  object pnlContorl: TPanel
    Left = 0
    Top = 0
    Width = 935
    Height = 105
    Align = alTop
    TabOrder = 0
    object lblDescroption: TLabel
      Left = 432
      Top = 4
      Width = 3
      Height = 13
      WordWrap = True
    end
    object btnSelectFile: TButton
      Left = 231
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Select file'
      TabOrder = 0
      OnClick = btnSelectFileClick
    end
    object edtImportFile: TEdit
      Left = 8
      Top = 16
      Width = 209
      Height = 21
      TabOrder = 1
    end
    object cbLogType: TComboBox
      Left = 8
      Top = 64
      Width = 209
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 2
      Text = 'Show full logs'
      Items.Strings = (
        'Show only errors'
        'Show full logs')
    end
    object btnStartImport: TButton
      Left = 231
      Top = 62
      Width = 75
      Height = 25
      Caption = 'Import'
      TabOrder = 3
      OnClick = btnStartImportClick
    end
  end
  object reditLogs: TcxRichEdit
    Left = 0
    Top = 105
    Align = alClient
    TabOrder = 1
    ExplicitTop = 16
    ExplicitHeight = 360
    Height = 376
    Width = 935
  end
  object OpenDialog1: TOpenDialog
    Left = 456
    Top = 152
  end
end
