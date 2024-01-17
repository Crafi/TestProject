unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.DApt;

type
  TDM = class(TDataModule)
    DB: TFDConnection;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    function GetQuery(const ASQL: string): TFDQuery;
  end;

var
  DM: TDM;

implementation

uses
  System.IniFiles, System.IOUtils, INI.Constants, VCL.Dialogs, Vcl.Forms;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
const
  sErrorConnecting = 'Error connecting to database - %s';
var
  LIniFile: TIniFile;
begin
  try
    LIniFile := TIniFile.Create(TPath.Combine(TPath.GetLibraryPath, C_INI_FILE_NAME));
    try
      DB.Params.Add('server=' + LIniFile.ReadString(C_DB_SECTION, C_DB_SERVER, EmptyStr));
      DB.Params.Database := LIniFile.ReadString(C_DB_SECTION, C_DB_DATABASE, EmptyStr);
      DB.Params.UserName := LIniFile.ReadString(C_DB_SECTION, C_DB_USER_NAME, EmptyStr);
      DB.Params.Password := LIniFile.ReadString(C_DB_SECTION, C_DB_PASSWORD, EmptyStr);
      DB.Open;
    finally
      LIniFile.Free;
    end;
  except
    on E:Exception do
    begin
      ShowMessage(Format(sErrorConnecting, [E.Message]));
      Application.Terminate;
    end;
  end;
end;

function TDM.GetQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(Self);
  Result.Connection := DB;
  Result.SQL.Text := ASQL;
end;

end.
