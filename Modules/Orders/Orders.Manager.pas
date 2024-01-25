unit Orders.Manager;

interface

type
  TOrdersManager = class
  private
    /// <summary>
    ///  Show form to edit/create order.
    ///  Return True if order has been updated.
    ///  Return False if user has used has been terminated edit.
    /// </summary>
    function ShowOrderEdit(ACustomerID: Integer; ADescription: string;
      AAmount: Double; AIsNew: Boolean; AID: Integer = -1): Boolean;
  public
    /// <summary>
    ///  Find and edit order by ID. Use UI.
    ///  Return True if order has been edited.
    ///  Return False if can't find order for edit or used has been terminated edit.
    /// </summary>
    function AddOrder: Boolean;
    /// <summary>
    ///  Add a new order. Use UI
    ///  Return True if order has been created.
    ///  Return False if used has been terminated edit.
    /// </summary>
    function EditOrder(AID: Integer): Boolean;
    /// <summary>
    ///  Delete a order by ID. Use UI
    ///  Return True if order has been deleted.
    ///  Return False if can't find order for edit or used has been terminated edit.
    /// </summary>
    function DeleteOrder(AID: Integer): Boolean;
  end;

function OrdersManager: TOrdersManager;

implementation

uses
  System.SysUtils, VCL.Controls, FormEditOrder, FireDAC.Comp.Client,
  FireDAC.Stan.Param, uDM, SQL.Constants, Customers.Manager;

var
  _OrderManager: TOrdersManager;

function OrdersManager: TOrdersManager;
begin
  if not Assigned(_OrderManager) then
    _OrderManager := TOrdersManager.Create;
  Result := _OrderManager;
end;

{ TOrderManager }

function TOrdersManager.AddOrder: Boolean;
begin
  Result := ShowOrderEdit(-1, EmptyStr, 0, True);
end;

function TOrdersManager.DeleteOrder(AID: Integer): Boolean;
var
  LQuery: TFDQuery;
  LAmount: Double;
  LCustomerID: Integer;
begin
  LQuery := DM.GetQuery(C_SELECT_ORDER_INFO_BY_ID);
  try
    LQuery.ParamByName('PID').AsInteger := AID;
    LQuery.Open;

    LAmount := LQuery.FieldByName('Amount').AsFloat;
    LCustomerID := LQuery.FieldByName('CustomerID').AsInteger;

    LQuery.SQL.Text := C_DELETE_ORDER;
    LQuery.ParamByName('PID').AsInteger := AID;
    LQuery.ExecSQL;

    Result := LQuery.RowsAffected > 0;
    if Result then
      CustomersManager.UpdateCustomerSalesVolume(LCustomerID, -LAmount);
  finally
    LQuery.Free;
  end;
end;

function TOrdersManager.EditOrder(AID: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := Dm.GetQuery(C_SELECT_ORDER_INFO_BY_ID);
  try
    LQuery.ParamByName('PID').AsInteger := AID;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
    begin
      Result := ShowOrderEdit(LQuery.FieldByName('CustomerID').AsInteger,
       LQuery.FieldByName('Description').AsWideString,
       LQuery.FieldByName('Amount').AsFloat,
       False, AID);
    end
    else
      Exit(False);
  finally
    LQuery.Free;
  end;
end;

function TOrdersManager.ShowOrderEdit(ACustomerID: Integer; ADescription: string;
  AAmount: Double; AIsNew: Boolean; AID: Integer): Boolean;
var
  LForm: TfrmEditOrder;
  LQuery: TFDQuery;
begin
  LForm := TfrmEditOrder.Create(nil);
  try
    LForm.cbCustomers.EditValue := ACustomerID;
    LForm.mmoDescription.Text := ADescription;
    LForm.edtAmount.Text := AAmount.ToString;
    LForm.StartAmount := AAmount;
    LForm.StartCustomerID := ACustomerID;

    Result := LForm.ShowModal = mrOk;
    if Result then
    begin
      if AIsNew then
        LQuery := DM.GetQuery(C_INSERT_ORDER)
      else
        LQuery := DM.GetQuery(C_UPDATE_ORDER);
      try
        LQuery.ParamByName('PCustomerID').AsInteger := LForm.cbCustomers.EditValue;
        LQuery.ParamByName('PDescription').AsWideString := LForm.mmoDescription.Text;
        LQuery.ParamByName('PAmount').AsFloat := StrToFloat(LForm.edtAmount.Text);

        if not AIsNew then
          LQuery.ParamByName('PID').AsInteger := AID
        else
          LQuery.ParamByName('PDate').AsDateTime := Now;

        LQuery.ExecSQL;
      finally
        LQuery.Free;
      end;

      //Revert customer sales, if we change customer in order
      if not AIsNew and (LForm.cbCustomers.EditValue <> ACustomerID) and
        (ACustomerID > -1) and (LForm.cbCustomers.EditValue > -1) then
      begin
        CustomersManager.UpdateCustomerSalesVolume(ACustomerID,
          -AAmount);
      end;

      CustomersManager.UpdateCustomerSalesVolume(LForm.cbCustomers.EditValue,
        LForm.CustomerAmount);
    end;
  finally
    LForm.Free;
  end;
end;

initialization

finalization
  FreeAndNil(_OrderManager);

end.
