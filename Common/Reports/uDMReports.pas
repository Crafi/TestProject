unit uDMReports;

interface

uses
  System.SysUtils, System.Classes, uDM, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, frxClass, frxDBSet;

type
  TDMReports = class(TDataModule)
    frxReportOrders: TfrxReport;
    FDQueryOrders: TFDQuery;
    DataSourceOrders: TDataSource;
    frxDBDatasetOrders: TfrxDBDataset;
    frxUserDataSet: TfrxUserDataSet;
    procedure frxUserDataSetGetValue(const VarName: string;
      var Value: Variant);
  private
    FDateFrom: TDateTime;
    FDateTo: TDateTime;
  public
    procedure ShowOrdersReport(ADateFrom, ADateTo: TDateTime; ACustomerID: Variant);
  end;

var
  DMReports: TDMReports;

implementation

uses
  System.Variants, System.DateUtils, SQL.Constants;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMReports }

procedure TDMReports.frxUserDataSetGetValue(const VarName: string;
  var Value: Variant);
begin
  //StartOfTheDay for remove time from TDateTIme
  if VarName.Equals('DateFrom') then
    Value := StartOfTheDay(FDateFrom)
  else
  if VarName.Equals('DateTo') then
    Value := StartOfTheDay(FDateTo);
end;

procedure TDMReports.ShowOrdersReport(ADateFrom, ADateTo: TDateTime;
  ACustomerID: Variant);
begin
  FDateFrom := ADateFrom;
  FDateTo := ADateTo;

  if ACustomerID = null then
    FDQueryOrders.SQL.Text := C_ORDERS_REPORT_DATE
  else
    FDQueryOrders.SQL.Text := C_ORDERS_REPORT_DATE_CUSTOMER;

  FDQueryOrders.ParamByName('PDateFrom').AsDateTime := StartOfTheDay(FDateFrom);
  FDQueryOrders.ParamByName('PDateTo').AsDateTime := EndOfTheDay(FDateTo);

  if ACustomerID <> null then
    DMReports.FDQueryOrders.ParamByName('PCustomerID').AsInteger := ACustomerID;

  FDQueryOrders.Open;

  frxReportOrders.ShowReport;
  FDQueryOrders.Close;
end;

end.
