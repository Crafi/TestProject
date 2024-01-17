inherited frmEditTransaction: TfrmEditTransaction
  Caption = 'Edit transaction'
  ClientHeight = 164
  OnCreate = FormCreate
  ExplicitHeight = 203
  PixelsPerInch = 96
  TextHeight = 15
  object lblCustomer: TLabel [0]
    Left = 32
    Top = 27
    Width = 55
    Height = 15
    Caption = 'Customer:'
  end
  object lblAmount: TLabel [1]
    Left = 32
    Top = 59
    Width = 47
    Height = 15
    Caption = 'Amount:'
  end
  inherited Panel1: TPanel
    Top = 106
    ExplicitTop = 137
  end
  object cbCustomers: TcxLookupComboBox
    Left = 264
    Top = 27
    Properties.DropDownAutoSize = True
    Properties.DropDownSizeable = True
    Properties.KeyFieldNames = 'ID'
    Properties.ListColumns = <
      item
        FieldName = 'Code'
      end
      item
        FieldName = 'Name'
      end
      item
        FieldName = 'Balance'
      end>
    Properties.ListFieldIndex = 1
    Properties.ListSource = dsCustomers
    TabOrder = 1
    Width = 185
  end
  object edtAmount: TEdit
    Left = 264
    Top = 59
    Width = 185
    Height = 23
    MaxLength = 12
    TabOrder = 2
    OnKeyPress = edtFloatNegativeKeyPress
  end
  object dsCustomers: TDataSource
    DataSet = QryCustomers
    Left = 504
    Top = 8
  end
  object QryCustomers: TFDQuery
    Connection = DM.DB
    Left = 464
    Top = 72
  end
end
