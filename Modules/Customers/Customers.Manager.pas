unit Customers.Manager;

interface

type
  TCustomersManager = class
  private
    /// <summary>
    ///  Show form to edit/create customer.
    ///  Return True if customer has been updated.
    ///  Return False if user has used has been terminated edit.
    /// </summary>
    function ShowCustomerEdit(ACode: Integer; const AName, AAddress, AVATNumber: string;
      ACreditLimit: Double; AIsNew: Boolean; AID: Integer = -1): Boolean;
    /// <summary>
    ///   Checking the customer for the ability to delete
    ///   If customer doesn't use in transaction(s) or order(s), return True
    ///   If customer use in transaction(s) or order(s), return False
    /// </summary>
    function CanDeleteCustomer(ACustomerID: Integer): Boolean;
  public
    /// <summary>
    ///  Find and edit customer by ID. Use UI.
    ///  Return True if customer has been edited.
    ///  Return False if can't find customer for edit or used has been terminated edit.
    /// </summary>
    function EditCustomer(ACustomerID: Integer): Boolean;
    /// <summary>
    ///  Add a new customer. Use UI
    ///  Return True if customer has been created.
    ///  Return False if used has been terminated edit.
    /// </summary>
    function AddCustomer: Boolean;
    /// <summary>
    ///  Delete a customer by ID. Use UI
    ///  Return True if customer has been deleted.
    ///  Return False if can't find customer for edit or used has been terminated edit.
    /// </summary>
    function DeleteCustomer(ACustomerID: Integer): Boolean;

    /// <summary>
    ///  Update customer sales volume
    ///  Return True if customer has been updated.
    ///  Return False if can't find customer.
    /// </summary>
    function UpdateCustomerSalesVolume(ACustomerID: Integer; AValue: Double): Boolean;
    /// <summary>
    ///  Update customer credit limit
    ///  Return True if customer has been updated.
    ///  Return False if can't find customer.
    /// </summary>
    function UpdateCustomerCreditLimit(ACustomerId: Integer; AValue: Double): Boolean;

    /// <summary>
    ///  Check customer code on dublicate. If AID <> -1, this is customer ID won't include in search
    ///  Return True if customer code is unique.
    ///  Return False if customer code is duplicate.
    /// </summary>
    function CheckCode(ACode: Integer; AID: Integer = -1): Boolean;
    /// <summary>
    ///  Check customer VAT number on dublicate. If AID <> -1, this is customer ID won't include in search
    ///  Return True if customer VAT number is unique.
    ///  Return False if customer VAT number is duplicate.
    /// </summary>
    function CheckVatNumber(const AVATNumber: string; AID: Integer = -1): Boolean;

    /// <summary>
    ///  Calculate and return customer balance by customer ID.
    ///  Return -1 if can't find customer
    /// </summary>
    function GetCustomerBalance(ACustomerID: Integer): Double;
    /// <summary>
    ///  Checking whether we can cancel a transaction for a customer.
    ///  Recalculate balance for new credit limit
    ///  If balance >= 0, return True
    ///  If balance < 0, return False
    /// </summary>
    function CanRevertCreditLimit(ACustomerID: Integer; AValue: Double): Boolean;
    /// <summary>
    ///  Find customer ID by cudtomer code.
    ///  Return -1 if can't find customer
    /// </summary>
    function FindCustomerIDByCode(ACode: Integer): Integer;
    /// <summary>
    ///   We can add negative transaction value.
    ///   If balance customer - transaction value >= 0, return True
    ///   If balance customer - transaction value < 0, return False
    /// </summary>
    function CanAddCustomerTransaction(ACustomerID: Integer; AValue: Double): Boolean;
  end;

  function CustomersManager: TCustomersManager;

implementation

uses
  System.SysUtils, VCL.Controls, uDM, SQL.Constants, FormEditCustomer,
  FireDAC.Comp.Client, FireDAC.Stan.Param, VCL.Dialogs;

var
  _CustomerManager: TCustomersManager;

function CustomersManager: TCustomersManager;
begin
  if not Assigned(_CustomerManager) then
    _CustomerManager := TCustomersManager.Create;
  Result := _CustomerManager;
end;

{ TCustomerManager }

function TCustomersManager.AddCustomer: Boolean;
begin
  Result := ShowCustomerEdit(0, EmptyStr, EmptyStr, EmptyStr, 0, True);
end;

function TCustomersManager.CanAddCustomerTransaction(ACustomerID: Integer;
  AValue: Double): Boolean;
begin
  Result := (GetCustomerBalance(ACustomerID) + AValue) >= 0;
end;

function TCustomersManager.CanDeleteCustomer(ACustomerID: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_SELECT_ORDERS_BY_CUSTOMER);
  try
    LQuery.ParamByName('PID').AsInteger := ACustomerID;
    LQuery.Open;

    Result := LQuery.FieldByName('Count').AsInteger = 0;
    if Result then
    begin
      LQuery.SQL.Text := C_SELECT_TRANSACTIONS_BY_CUSTOMER;
      LQuery.ParamByName('PID').AsInteger := ACustomerID;
      LQuery.Open;

      Result := LQuery.FieldByName('Count').AsInteger = 0;
    end;

    if not Result then
      ShowMessage('You cannot delete a customer that is used in transaction(s) or order(s)');
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.CanRevertCreditLimit(ACustomerID: Integer; AValue: Double): Boolean;
begin
  Result := GetCustomerBalance(ACustomerID) >= AValue;
end;

function TCustomersManager.CheckCode(ACode: Integer; AID: Integer = -1): Boolean;
var
  LQuery: TFDQuery;
begin
  if AID = -1 then
    LQuery := DM.GetQuery(C_FIND_CUSTOMER_BY_CODE)
  else
    LQuery := DM.GetQuery(C_FIND_CUSTOMER_BY_CODE_EDIT);
  try
    LQuery.ParamByName('PCode').AsInteger := ACode;
    if AID <> -1 then
      LQuery.ParamByName('PID').AsInteger := AID;
    LQuery.Open;
    Result := LQuery.RecordCount > 0;
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.CheckVatNumber(const AVATNumber: string; AID: Integer = -1): Boolean;
var
  LQuery: TFDQuery;
begin
  if AID = -1 then
    LQuery := DM.GetQuery(C_FIND_CUSTOMER_BY_VAT_NUMBER)
  else
    LQuery := DM.GetQuery(C_FIND_CUSTOMER_BY_VAT_NUMBER_EDIT);
  try
    LQuery.ParamByName('PVATNumber').AsWideString := AVATNumber;
    if AID <> -1 then
      LQuery.ParamByName('PID').AsInteger := AID;
    LQuery.Open;
    Result := LQuery.RecordCount > 0;
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.DeleteCustomer(ACustomerID: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  if not CanDeleteCustomer(ACustomerID) then
    Exit(False);

  LQuery := DM.GetQuery(C_DELETE_CUSTOMER);
  try
    LQuery.ParamByName('PID').AsInteger := ACustomerID;
    LQuery.ExecSQL;
    Result := LQuery.RowsAffected > 0;
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.EditCustomer(ACustomerID: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_SELECT_CUSTOMER_BY_ID);
  try
    LQuery.ParamByName('PID').AsInteger := ACustomerID;
    LQuery.Open;
    if LQuery.RecordCount > 0 then
    begin
      Result := ShowCustomerEdit(LQuery.FieldByName('Code').AsInteger,
        LQuery.FieldByName('Name').AsWideString,
        LQuery.FieldByName('Address').AsWideString,
        LQuery.FieldByName('VATNumber').AsWideString,
        LQuery.FieldByName('CreditLimit').AsFloat, False, ACustomerID);
    end
    else
      Exit(False);
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.GetCustomerBalance(ACustomerID: Integer): Double;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_SELECT_CUSTOMER_BALANCE_BY_ID);
  try
    LQuery.ParamByName('PID').AsInteger := ACustomerID;
    LQuery.Open;
    if LQuery.RecordCount > 0 then
      Result := LQuery.FieldByName('Balance').AsFloat
    else
      Result := 0;
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.FindCustomerIDByCode(ACode: Integer): Integer;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_SELECT_CUSTOMER_BY_CODE);
  try
    LQuery.ParamByName('PCode').AsInteger := ACode;
    LQuery.Open;
    if LQuery.RecordCount > 0 then
      Result := LQuery.FieldByName('ID').AsInteger
    else
      Result := -1;
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.ShowCustomerEdit(ACode: Integer; const AName,
  AAddress, AVATNumber: string; ACreditLimit: Double; AIsNew: Boolean; AID: Integer): Boolean;
var
  LFormEditCustomer: TfrmEditCustomer;
  LQuery: TFDQuery;
begin
  LFormEditCustomer := TfrmEditCustomer.Create(nil);
  try
    LFormEditCustomer.edtCode.Text := ACode.ToString;
    LFormEditCustomer.edtName.Text := AName;
    LFormEditCustomer.edtAddress.Text := AAddress;
    LFormEditCustomer.edtVATNumber.Text := AVATNumber;

    if not AIsNew then
      LFormEditCustomer.ID := AID;

    Result := LFormEditCustomer.ShowModal = mrOk;
    if Result then
    begin
      if AIsNew then
        LQuery := DM.GetQuery(C_INSERT_CUSTOMER)
      else
        LQuery := DM.GetQuery(C_UPDATE_CUSTOMER);
      try
        LQuery.ParamByName('PCode').AsInteger := StrToInt(LFormEditCustomer.edtCode.Text);
        LQuery.ParamByName('PName').AsWideString := LFormEditCustomer.edtName.Text;
        LQuery.ParamByName('PAddress').AsWideString := LFormEditCustomer.edtAddress.Text;
        LQuery.ParamByName('PVATNumber').AsWideString := LFormEditCustomer.edtVATNumber.Text;

        if not AIsNew then
          LQuery.ParamByName('PID').AsInteger := AID;

        LQuery.ExecSQL;
      finally
        LQuery.Free;
      end;
    end;
  finally
    LFormEditCustomer.Free;
  end;
end;

function TCustomersManager.UpdateCustomerCreditLimit(ACustomerId: Integer;
  AValue: Double): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_UPDATE_CUSTOMER_CREDIT_LIMIT_BY_ID);
  try
    LQuery.ParamByName('PCreditLimit').AsFloat := AValue;
    LQuery.ParamByName('PID').AsInteger := ACustomerID;
    LQuery.ExecSQL;

    Result := LQuery.RowsAffected > 0;
  finally
    LQuery.Free;
  end;
end;

function TCustomersManager.UpdateCustomerSalesVolume(ACustomerID: Integer;
  AValue: Double): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_UPDATE_CUSTOMER_SALES_VOLUME_BY_ID);
  try
    LQuery.ParamByName('PSalesVolume').AsFloat := AValue;
    LQuery.ParamByName('PID').AsInteger := ACustomerID;
    LQuery.ExecSQL;

    Result := LQuery.RowsAffected > 0;
  finally
    LQuery.Free;
  end;
end;

initialization

finalization
  FreeAndNil(_CustomerManager);

end.
