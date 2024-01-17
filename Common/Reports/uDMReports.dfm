object DMReports: TDMReports
  OldCreateOrder = False
  Height = 179
  Width = 323
  object frxReportOrders: TfrxReport
    Version = '5.1.5'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45307.901778483800000000
    ReportOptions.LastChange = 45307.901778483800000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 192
    Top = 16
    Datasets = <
      item
        DataSet = frxDBDatasetOrders
        DataSetName = 'OrdersReport'
      end
      item
        DataSet = frxUserDataSet
        DataSetName = 'ReportOptions'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 18.897650000000000000
        Top = 151.181200000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetOrders
        DataSetName = 'OrdersReport'
        RowCount = 0
        object Memo1: TfrxMemoView
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'Order ID')
        end
        object Memo2: TfrxMemoView
          Left = 124.724490000000000000
          Width = 162.519790000000000000
          Height = 18.897650000000000000
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'Order date')
        end
        object Memo3: TfrxMemoView
          Left = 287.244280000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'Customer code')
        end
        object Memo4: TfrxMemoView
          Left = 445.984540000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'Customer name')
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Height = 18.897650000000000000
        Top = 192.756030000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetOrders
        DataSetName = 'OrdersReport'
        RowCount = 0
        object Cardprice: TfrxMemoView
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          DataSetName = 'Card'
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[OrdersReport."ID"]')
        end
        object Memo5: TfrxMemoView
          Left = 124.724490000000000000
          Width = 162.519790000000000000
          Height = 18.897650000000000000
          DataSetName = 'Card'
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[OrdersReport."Date"]')
        end
        object Memo6: TfrxMemoView
          Left = 287.244280000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataSetName = 'Card'
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '[OrdersReport."CustomerCode"]')
        end
        object Memo7: TfrxMemoView
          Left = 445.984540000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          DataSetName = 'Card'
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '[OrdersReport."CustomerName"]')
        end
      end
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Height = 71.811070000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo8: TfrxMemoView
          Align = baCenter
          Left = -18.897405905511800000
          Top = 18.897650000000000000
          Width = 755.905511811023600000
          Height = 37.795275590000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -24
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              'Orders report from [ReportOptions."DateFrom"] to [ReportOptions.' +
              '"DateTo"]'
            '')
          ParentFont = False
        end
      end
    end
  end
  object FDQueryOrders: TFDQuery
    Connection = DM.DB
    SQL.Strings = (
      'SELECT Orders.*,'
      'Customers.Name AS CustomerName, Customers.Code AS CustomerCode'
      'FROM Orders'
      'INNER JOIN Customers ON Customers.ID = Orders.CustomerID ')
    Left = 16
    Top = 16
  end
  object DataSourceOrders: TDataSource
    DataSet = FDQueryOrders
    Left = 72
    Top = 16
  end
  object frxDBDatasetOrders: TfrxDBDataset
    UserName = 'OrdersReport'
    CloseDataSource = False
    DataSource = DataSourceOrders
    BCDToCurrency = False
    Left = 128
    Top = 16
  end
  object frxUserDataSet: TfrxUserDataSet
    UserName = 'ReportOptions'
    Fields.Strings = (
      'DateFrom'
      'DateTo')
    OnGetValue = frxUserDataSetGetValue
    Left = 8
    Top = 72
  end
end
