object frmReports: TfrmReports
  Left = 0
  Top = 0
  Width = 1012
  Height = 486
  TabOrder = 0
  object btnOrdersReport: TButton
    Left = 8
    Top = 72
    Width = 97
    Height = 33
    Caption = 'Orders report'
    TabOrder = 0
    OnClick = btnOrdersReportClick
  end
  object pnlControls: TPanel
    Left = 0
    Top = 0
    Width = 1012
    Height = 57
    Align = alTop
    TabOrder = 1
    object lblCustomer: TLabel
      Left = 552
      Top = 19
      Width = 50
      Height = 13
      Caption = 'Customer:'
    end
    object lblDateFrom: TLabel
      Left = 8
      Top = 19
      Width = 48
      Height = 13
      Caption = 'Date from'
    end
    object lblDateTo: TLabel
      Left = 254
      Top = 19
      Width = 35
      Height = 13
      Caption = 'date to'
    end
    object cbCustomers: TcxLookupComboBox
      Left = 608
      Top = 16
      Properties.DropDownAutoSize = True
      Properties.DropDownSizeable = True
      Properties.KeyFieldNames = 'ID'
      Properties.ListColumns = <
        item
          FieldName = 'Code'
        end
        item
          FieldName = 'Name'
        end>
      Properties.ListFieldIndex = 1
      Properties.ListSource = dsCustomers
      TabOrder = 0
      Width = 185
    end
    object dtFrom: TDateTimePicker
      Left = 62
      Top = 16
      Width = 186
      Height = 21
      Date = 45307.897846400460000000
      Time = 45307.897846400460000000
      TabOrder = 1
    end
    object dtTo: TDateTimePicker
      Left = 295
      Top = 16
      Width = 186
      Height = 21
      Date = 45307.897846400460000000
      Time = 45307.897846400460000000
      TabOrder = 2
    end
  end
  object dsCustomers: TDataSource
    DataSet = QryCustomers
    Left = 880
    Top = 40
  end
  object QryCustomers: TFDQuery
    Connection = DM.DB
    Left = 904
    Top = 88
  end
end
