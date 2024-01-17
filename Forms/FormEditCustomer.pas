unit FormEditCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormBaseEdit, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmEditCustomer = class(TfrmBaseEdit)
    edtCode: TEdit;
    edtName: TEdit;
    edtAddress: TEdit;
    edtVATNumber: TEdit;
    lblCode: TLabel;
    lblName: TLabel;
    lblAddress: TLabel;
    lblVATNumber: TLabel;
    procedure FormCreate(Sender: TObject);
  protected
    function CheckData: Boolean; override;
  public
    { Public declarations }
  end;

var
  frmEditCustomer: TfrmEditCustomer;

implementation

uses
  Customers.Manager;

{$R *.dfm}

function TfrmEditCustomer.CheckData: Boolean;
begin
  Result := True;

  if edtCode.Text = EmptyStr then
  begin
    ShowMessage('Code cannot be empty');
    Result := False;
  end;

  if edtCode.Text = EmptyStr then
  begin
    ShowMessage('Name cannot be empty');
    Result := False;
  end;

  if edtVATNumber.Text = EmptyStr then
  begin
    ShowMessage('VAT number cannot be empty');
    Result := False;
  end;

  //Start check in DB only without empty fields
  if not Result then
    Exit;

  if CustomersManager.CheckCode(StrToInt(edtCode.Text), ID) then
  begin
    ShowMessage('The customer code must be unique');
    Result := False;
  end;

  if CustomersManager.CheckVatNumber(edtVATNumber.Text, ID) then
  begin
    ShowMessage('The VAT number of the customer must be unique');
    Result := False;
  end;
end;


procedure TfrmEditCustomer.FormCreate(Sender: TObject);
begin
  inherited;
  ActiveControl := edtCode;
end;

end.
