inherited frmEditOrder: TfrmEditOrder
  Caption = 'Edit order'
  ClientHeight = 268
  ExplicitHeight = 307
  PixelsPerInch = 96
  TextHeight = 15
  object lblDescription: TLabel [2]
    Left = 32
    Top = 94
    Width = 63
    Height = 15
    Caption = 'Description:'
  end
  inherited Panel1: TPanel
    Top = 210
    ExplicitTop = 227
  end
  inherited edtAmount: TEdit
    OnKeyPress = edtFloatKeyPress
  end
  object mmoDescription: TMemo [6]
    Left = 264
    Top = 94
    Width = 313
    Height = 89
    Lines.Strings = (
      '')
    MaxLength = 100
    TabOrder = 3
  end
end
