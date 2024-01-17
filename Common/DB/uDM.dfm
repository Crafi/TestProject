object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 80
  Width = 189
  object DB: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 112
    Top = 16
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 32
    Top = 16
  end
end
