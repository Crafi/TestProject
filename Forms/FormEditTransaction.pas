unit FormEditTransaction;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormBaseEdit, Vcl.StdCtrls, Vcl.ExtCtrls, uDM,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox;

type
  TfrmEditTransaction = class(TfrmBaseEdit)
    lblCustomer: TLabel;
    cbCustomers: TcxLookupComboBox;
    dsCustomers: TDataSource;
    QryCustomers: TFDQuery;
    edtAmount: TEdit;
    lblAmount: TLabel;
    procedure FormCreate(Sender: TObject);
  private
  protected
    //Amount for change in customer table
    //For insert - full amount
    //For update - previous value - current
    FCustomerAmount: Double;
    //Started value for amount
    //For insert - 0
    //For update - current value for order
    FStartAmount: Double;
    //If we edit customer, started amount will be 0
    FStartCustomerID: Integer;
  protected
    function CheckData: Boolean; override;
  public
    property StartAmount: Double write FStartAmount;
    property CustomerAmount: Double read FCustomerAmount;
    property StartCustomerID: Integer write FStartCustomerID;
  end;

var
  frmEditTransaction: TfrmEditTransaction;

implementation

uses
  SQL.Constants;

{$R *.dfm}

function TfrmEditTransaction.CheckData: Boolean;
var
  LAmount: Double;
begin
  Result := True;
  if cbCustomers.ItemIndex = -1 then
  begin
    ShowMessage('You need to choose a customer!');
    Exit(False);
  end;

  if edtAmount.Text = EmptyStr then
  begin
    ShowMessage('Amount cannot be empty');
    Result := False;
  end
  else
  begin
    LAmount := StrToFloat(edtAmount.Text);
    if FStartCustomerID <> cbCustomers.EditValue  then
      FCustomerAmount := LAmount
    else
      FCustomerAmount := LAmount - FStartAmount;

    if LAmount = 0 then
    begin
      ShowMessage('The amount must be greater than 0');
      Result := False;
    end
  end;
end;

procedure TfrmEditTransaction.FormCreate(Sender: TObject);
begin
  inherited;
  QryCustomers.Open(C_SELECT_CUSTOMERS);
  ActiveControl := cbCustomers;
end;

end.
