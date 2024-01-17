object frmBaseEdit: TfrmBaseEdit
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'frmBaseEdit'
  ClientHeight = 466
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 408
    Width = 620
    Height = 58
    Align = alBottom
    TabOrder = 0
    object btnOk: TButton
      Left = 48
      Top = 16
      Width = 90
      Height = 25
      Align = alCustom
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 472
      Top = 16
      Width = 90
      Height = 25
      Align = alCustom
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
