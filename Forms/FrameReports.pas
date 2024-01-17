unit FrameReports;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  Vcl.StdCtrls, Vcl.ComCtrls, uDM, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls;

type
  TfrmReports = class(TFrame)
    btnOrdersReport: TButton;
    dtFrom: TDateTimePicker;
    dtTo: TDateTimePicker;
    lblDateFrom: TLabel;
    lblDateTo: TLabel;
    lblCustomer: TLabel;
    dsCustomers: TDataSource;
    QryCustomers: TFDQuery;
    cbCustomers: TcxLookupComboBox;
    pnlControls: TPanel;
    procedure btnOrdersReportClick(Sender: TObject);
  private
    function CheckReportsDate: Boolean;
  public
    constructor Create(AParent: TComponent); override;
  end;

implementation

uses
  System.DateUtils, uDMReports, SQL.Constants;

{$R *.dfm}

procedure TfrmReports.btnOrdersReportClick(Sender: TObject);
begin
  if not CheckReportsDate then
    Exit;
  DMReports.ShowOrdersReport(dtFrom.Date, dtTo.Date, cbCustomers.EditValue);
end;

function TfrmReports.CheckReportsDate: Boolean;
begin
  Result := dtFrom.Date <= dtTo.Date;

  if not Result then
    ShowMessage('The date from must be less than the date to');
end;

constructor TfrmReports.Create(AParent: TComponent);
begin
  inherited Create(AParent);
  QryCustomers.Open(C_SELECT_CUSTOMERS);
  dtFrom.Date := IncDay(Now, -7);
  dtTo.Date := Now;
end;

end.

