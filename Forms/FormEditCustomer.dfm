inherited frmEditCustomer: TfrmEditCustomer
  Caption = 'Edit customer'
  ClientHeight = 230
  OnCreate = FormCreate
  ExplicitWidth = 636
  ExplicitHeight = 269
  PixelsPerInch = 96
  TextHeight = 15
  object lblCode: TLabel [0]
    Left = 32
    Top = 27
    Width = 31
    Height = 15
    Caption = 'Code:'
  end
  object lblName: TLabel [1]
    Left = 32
    Top = 62
    Width = 35
    Height = 15
    Caption = 'Name:'
  end
  object lblAddress: TLabel [2]
    Left = 32
    Top = 97
    Width = 45
    Height = 15
    Caption = 'Address:'
  end
  object lblVATNumber: TLabel [3]
    Left = 32
    Top = 132
    Width = 67
    Height = 15
    Caption = 'VAT number:'
  end
  inherited Panel1: TPanel
    Top = 172
    ExplicitTop = 172
    ExplicitWidth = 611
  end
  object edtCode: TEdit
    Left = 264
    Top = 24
    Width = 233
    Height = 23
    MaxLength = 10
    TabOrder = 1
    OnKeyPress = edtIntegerKeyPress
  end
  object edtName: TEdit
    Left = 264
    Top = 59
    Width = 233
    Height = 23
    MaxLength = 100
    TabOrder = 2
  end
  object edtAddress: TEdit
    Left = 264
    Top = 94
    Width = 233
    Height = 23
    MaxLength = 100
    TabOrder = 3
  end
  object edtVATNumber: TEdit
    Left = 264
    Top = 129
    Width = 233
    Height = 23
    MaxLength = 11
    TabOrder = 4
  end
end
