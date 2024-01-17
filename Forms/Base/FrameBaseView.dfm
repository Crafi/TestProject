object frmBaseView: TfrmBaseView
  Left = 0
  Top = 0
  Width = 1049
  Height = 605
  TabOrder = 0
  object pnlControl: TPanel
    Left = 0
    Top = 0
    Width = 1049
    Height = 57
    Align = alTop
    TabOrder = 0
    object btnAdd: TButton
      AlignWithMargins = True
      Left = 9
      Top = 17
      Width = 75
      Height = 23
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 16
      Align = alLeft
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      AlignWithMargins = True
      Left = 100
      Top = 17
      Width = 75
      Height = 23
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 16
      Align = alLeft
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      AlignWithMargins = True
      Left = 191
      Top = 17
      Width = 75
      Height = 23
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 16
      Align = alLeft
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnRefresh: TButton
      AlignWithMargins = True
      Left = 282
      Top = 17
      Width = 75
      Height = 23
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 16
      Align = alLeft
      Caption = 'Refresh'
      TabOrder = 3
      OnClick = btnRefreshClick
    end
  end
  object Grid: TcxGrid
    Left = 0
    Top = 57
    Width = 1049
    Height = 548
    Align = alClient
    TabOrder = 1
    object TableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      FindPanel.Behavior = fcbSearch
      FindPanel.DisplayMode = fpdmManual
      FindPanel.Layout = fplCompact
      FindPanel.UseExtendedSyntax = True
      FindPanel.Location = fplGroupByBox
      FindPanel.SearchInGroupRows = True
      FindPanel.SearchInPreview = True
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      FilterRow.Visible = True
      OptionsSelection.CellSelect = False
      OptionsView.GroupByBox = False
    end
    object GridLevel: TcxGridLevel
      GridView = TableView
    end
  end
  object FDQuery: TFDQuery
    Connection = DM.DB
    Left = 496
    Top = 16
  end
  object DataSource: TDataSource
    DataSet = FDQuery
    Left = 552
    Top = 16
  end
end
