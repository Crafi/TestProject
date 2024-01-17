unit FormEditOrder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FormEditTransaction, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.StdCtrls, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, Vcl.ExtCtrls;

type
  TfrmEditOrder = class(TfrmEditTransaction)
    mmoDescription: TMemo;
    lblDescription: TLabel;
  private
    { Private declarations }
  protected
    function CheckData: Boolean; override;
  public
    { Public declarations }
  end;

var
  frmEditOrder: TfrmEditOrder;

implementation

uses
  Customers.Manager;

{$R *.dfm}

{ TfrmEditOrder }

function TfrmEditOrder.CheckData: Boolean;
begin
  Result := inherited CheckData;

  if not Result then
    Exit;

  if CustomersManager.GetCustomerBalance(cbCustomers.EditValue) < CustomerAmount then
  begin
    ShowMessage('Insufficient customer credit limit');
    Result := False;
  end;

end;

end.
