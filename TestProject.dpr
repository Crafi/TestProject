program TestProject;

uses
  Vcl.Forms,
  FormMain in 'Forms\FormMain.pas' {frmMain},
  uDM in 'Common\DB\uDM.pas' {DM: TDataModule},
  Customers.Manager in 'Modules\Customers\Customers.Manager.pas',
  SQL.Constants in 'Common\Globals\SQL.Constants.pas',
  FrameBaseView in 'Forms\Base\FrameBaseView.pas' {frmBaseView: TFrame},
  FormBaseEdit in 'Forms\Base\FormBaseEdit.pas' {frmBaseEdit},
  FormEditCustomer in 'Forms\FormEditCustomer.pas' {frmEditCustomer},
  Orders.Manager in 'Modules\Orders\Orders.Manager.pas',
  FormEditOrder in 'Forms\FormEditOrder.pas' {frmEditOrder},
  FormEditTransaction in 'Forms\FormEditTransaction.pas' {frmEditTransaction},
  Transactions.Manager in 'Modules\Transactions\Transactions.Manager.pas',
  FrameImportCSV in 'Forms\FrameImportCSV.pas' {frmImportCSV: TFrame},
  FrameReports in 'Forms\FrameReports.pas' {frmReports: TFrame},
  uDMReports in 'Common\Reports\uDMReports.pas' {DMReports: TDataModule},
  INI.Constants in 'Common\Globals\INI.Constants.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TDMReports, DMReports);
  Application.Run;
end.
