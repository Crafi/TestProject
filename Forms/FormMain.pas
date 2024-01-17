unit FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dxBarBuiltInMenu,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, Vcl.Menus,
  FrameBaseView;

type
  TfrmMain = class(TForm)
    cxPageControl: TcxPageControl;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    ShowCustomers: TMenuItem;
    ShowOrders: TMenuItem;
    ShowTransactions: TMenuItem;
    Import: TMenuItem;
    ShowReports: TMenuItem;
    procedure ShowCustomersClick(Sender: TObject);
    procedure ShowOrdersClick(Sender: TObject);
    procedure ShowTransactionsClick(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure ShowReportsClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
  private
    procedure OpenSheet(const ACaption: string; ADoShowFrame: TProc<TWinControl>);

    procedure ShowViewFrame(AParent: TWinControl; const ASQL: string;
      AColumnsName, AColumnsCaption: TArray<string>; ADoAdd: TFunc<Boolean>;
      ADoEdit: TFunc<Integer, Boolean>; ADoDelete: TFunc<Integer, Boolean>;
      const AIDName: string = 'ID');

    procedure SetupFrame(AFrame: TFrame; AParent: TWinControl);

    procedure ShowCustomersFrame(AParent: TWinControl);
    procedure ShowOrdersFrame(APArent: TWinControl);
    procedure ShowTransactionsFrame(AParent: TWinControl);
    procedure ShowImportCSV(AParent: TWinControl);
    procedure ShowReportsFrame(AParent: TWinControl);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Customers.Manager, Orders.Manager, Transactions.Manager, SQL.Constants,
  FrameImportCSV, FrameReports;

{$R *.dfm}

procedure TfrmMain.ShowCustomersFrame(AParent: TWinControl);
begin
  ShowViewFrame(AParent, C_SELECT_CUSTOMERS, ['Code', 'Name', 'Address', 'VATNumber',
    'CreditLimit', 'SalesVolume', 'Balance'],
    ['Code', 'Name', 'Address', 'VAT number', 'Credit limit', 'Sales volume', 'Balance'],
    CustomersManager.AddCustomer, CustomersManager.EditCustomer,
    CustomersManager.DeleteCustomer);
end;

procedure TfrmMain.ShowTransactionsFrame(APArent: TWinControl);
begin
  ShowViewFrame(APArent, C_SELECT_TRANSACTIONS, ['ID', 'Date', 'Amount', 'CustomerName', 'CustomerCode'],
    ['Transaction ID', 'Transaction date', 'Amount', 'Customer name', 'Customer code'],
    TransactionsManager.AddTransaction, TransactionsManager.EditTransaction,
    TransactionsManager.DeleteTransaction);
end;

procedure TfrmMain.ShowOrdersFrame(APArent: TWinControl);
begin
  ShowViewFrame(AParent, C_SELECT_ORDERS, ['ID', 'Date', 'Description', 'Amount', 'CustomerName', 'CustomerCode'],
    ['Order ID', 'Document date', 'Description', 'Amount', 'Customer name', 'Customer code'],
    OrdersManager.AddOrder, OrdersManager.EditOrder, OrdersManager.DeleteOrder);
end;

procedure TfrmMain.ShowImportCSV(AParent: TWinControl);
var
  LFrame: TfrmImportCSV;
begin
  LFrame := TfrmImportCSV.Create(AParent);
  SetupFrame(LFrame, AParent);
end;

procedure TfrmMain.ShowReportsFrame(AParent: TWinControl);
var
  LFrame: TfrmReports;
begin
  LFrame := TfrmReports.Create(AParent);
  SetupFrame(LFrame, AParent);
end;

procedure TfrmMain.ShowViewFrame(AParent: TWinControl; const ASQL: string;
  AColumnsName, AColumnsCaption: TArray<string>; ADoAdd: TFunc<Boolean>;
  ADoEdit, ADoDelete: TFunc<Integer, Boolean>; const AIDName: string);
var
  LFrame: TfrmBaseView;
begin
  LFrame := TfrmBaseView.Create(AParent);
  LFrame.InitData(ASQL, AColumnsName, AColumnsCaption, AIDName);
  LFrame.DoAdd := ADoAdd;
  LFrame.DoEdit := ADoEdit;
  LFrame.DoDelete := ADoDelete;
  SetupFrame(LFrame, AParent);
end;

procedure TfrmMain.SetupFrame(AFrame: TFrame; AParent: TWinControl);
begin
  AFrame.Parent := AParent;
  AFrame.Align := TAlign.alClient;
end;

procedure TfrmMain.ShowCustomersClick(Sender: TObject);
begin
  OpenSheet(TMenuItem(Sender).Caption, ShowCustomersFrame);
end;

procedure TfrmMain.ShowTransactionsClick(Sender: TObject);
begin
  OpenSheet(TMenuItem(Sender).Caption, ShowTransactionsFrame);
end;

procedure TfrmMain.ShowOrdersClick(Sender: TObject);
begin
  OpenSheet(TMenuItem(Sender).Caption, ShowOrdersFrame);
end;

procedure TfrmMain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
const
  C_MIN_WIDTH = 640;
  C_MIN_HEIGHT = 480;
begin
  Resize := (NewWidth >= C_MIN_WIDTH) or (NewHeight >= C_MIN_HEIGHT);
end;

procedure TfrmMain.ImportClick(Sender: TObject);
begin
  OpenSheet(TMenuItem(Sender).Caption, ShowImportCSV);
end;

procedure TfrmMain.ShowReportsClick(Sender: TObject);
begin
  OpenSheet(TMenuItem(Sender).Caption, ShowReportsFrame);
end;

procedure TfrmMain.OpenSheet(const ACaption: string; ADoShowFrame: TProc<TWinControl>);
const
  C_PREFIX_SHEET = 'tab_';

var
  i: Integer;
  LSheet: TcxTabSheet;
  LCaption: string;
begin
  //if we use caption from component name, it can include fast button &
  LCaption := ACaption.Replace('&', '', [rfReplaceAll]);

  for i := 0 to Pred(cxPageControl.PageCount) do
  begin
    if cxPageControl.Pages[i].Name = C_PREFIX_SHEET + LCaption then
    begin
      cxPageControl.Pages[i].Show;
      Exit;
    end;
  end;

  LSheet := TcxTabSheet.Create(cxPageControl);
  LSheet.PageControl := cxPageControl;
  LSheet.Caption := LCaption;
  LSheet.Name := C_PREFIX_SHEET + LCaption;

  if Assigned(ADoShowFrame) then
    ADoShowFrame(LSheet);

  LSheet.Show;
end;

end.
