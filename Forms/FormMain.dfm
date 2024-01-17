object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Test application'
  ClientHeight = 532
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCanResize = FormCanResize
  PixelsPerInch = 96
  TextHeight = 13
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 0
    Width = 929
    Height = 532
    Align = alClient
    TabOrder = 0
    Properties.CloseButtonMode = cbmEveryTab
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 528
    ClientRectLeft = 4
    ClientRectRight = 925
    ClientRectTop = 4
  end
  object MainMenu: TMainMenu
    Left = 368
    Top = 256
    object File1: TMenuItem
      Caption = 'File'
      object ShowCustomers: TMenuItem
        Caption = 'Customers'
        OnClick = ShowCustomersClick
      end
      object ShowTransactions: TMenuItem
        Caption = 'Transactions'
        OnClick = ShowTransactionsClick
      end
      object ShowOrders: TMenuItem
        Caption = 'Orders'
        OnClick = ShowOrdersClick
      end
    end
    object Import: TMenuItem
      Caption = 'Import'
      OnClick = ImportClick
    end
    object ShowReports: TMenuItem
      Caption = 'Reports'
      OnClick = ShowReportsClick
    end
  end
end
