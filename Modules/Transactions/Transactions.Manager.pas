unit Transactions.Manager;

interface

type
  TTransactionsManager = class
  private
    /// <summary>
    ///  Check customer on revert transaction.
    ///  If can rever, return True.
    ///  If can't revert, return False.
    /// </summary>
    function CheckOnRevert(ACustomerID: Integer; AAmount: Double): Boolean;
    /// <summary>
    ///   Show form to edit/create transaction.
    ///   Return True if transaction has been updated.
    ///   Return False if user has used has been terminated edit.
    /// </summary>
    function ShowTransactionEdit(ACustomerID: Integer; AAmount: Double;
      AIsNew: Boolean; AID: Integer = -1): Boolean;
    /// <summary>
    ///   Check all condition for add transaction.
    ///   If can add transaction, return True.
    ///   If can not add transaction, return False.
    /// </summary>
    function CanAddTransaction(ACustomerID: Integer; AAmount: Double;
      var AError: string) : Boolean;
  public
    /// <summary>
    ///  Find and edit transaction by ID. Use UI.
    ///  Return True if transaction has been edited.
    ///  Return False if can't find transaction for edit or used has been terminated edit.
    /// </summary>
    function AddTransaction: Boolean; overload;
    /// <summary>
    ///   Create transaction by customer code and amount.
    ///   If can create, return true.
    ///   If can't create, return False and error message in AError.
    /// </summary>
    function AddTransaction(ACustomerCode: Integer; AAmount: Double;
      var AError: string): Boolean; overload;
    /// <summary>
    ///  Add a new transaction. Use UI
    ///  Return True if transaction has been created.
    ///  Return False if used has been terminated edit.
    /// </summary>
    function EditTransaction(ATransactionID: Integer): Boolean;
    /// <summary>
    ///  Delete a transaction by ID. Use UI
    ///  Return True if transaction has been deleted.
    ///  Return False if can't find transaction for edit or used has been terminated edit.
    /// </summary>
    function DeleteTransaction(ATransactionID: Integer): Boolean;
  end;

function TransactionsManager: TTransactionsManager;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param, uDM, SQL.Constants,
  FormEditTransaction, VCL.Controls, Customers.Manager, VCL.Dialogs;

var
  _TransactionManager: TTransactionsManager;

function TransactionsManager: TTransactionsManager;
begin
  if not Assigned(_TransactionManager) then
    _TransactionManager := TTransactionsManager.Create;
  Result := _TransactionManager;
end;

{ TTransactionManager }

function TTransactionsManager.AddTransaction: Boolean;
begin
  Result := ShowTransactionEdit(-1, 0, True);
end;

function TTransactionsManager.AddTransaction(ACustomerCode: Integer;
  AAmount: Double; var AError: string): Boolean;
var
  LCustomerID: Integer;
  LQuery: TFDQuery;
begin
  LCustomerID := CustomersManager.FindCustomerIDByCode(ACustomerCode);
  if LCustomerID = -1 then
  begin
    AError := 'Customer code not found!';
    Exit(False);
  end;

  if not CanAddTransaction(LCustomerID, AAmount, AError) then
    Exit(False);

  try
    LQuery := DM.GetQuery(C_INSERT_TRANSACTION);
    try
      LQuery.ParamByName('PCustomerID').AsInteger := LCustomerID;
      LQuery.ParamByName('PDate').AsDateTime := Now;
      LQuery.ParamByName('PAmount').AsFloat := AAmount;
      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;

    CustomersManager.UpdateCustomerCreditLimit(LCustomerID, AAmount);
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      AError := E.Message;
    end;
  end;
end;

function TTransactionsManager.CanAddTransaction(ACustomerID: Integer;
  AAmount: Double; var AError: string): Boolean;
begin
  AError := EmptyStr;
  Result := CustomersManager.CanAddCustomerTransaction(ACustomerID, AAmount);
  if not Result then
    AError := 'Customer balance cannot be negative'
  else
    AError := EmptyStr;
end;

function TTransactionsManager.CheckOnRevert(ACustomerID: Integer;
  AAmount: Double): Boolean;
begin
  Result := CustomersManager.CanRevertCreditLimit(ACustomerID, AAmount);
  if not Result then
    ShowMessage('The customer''s balance does not allow the transaction to be cancelled')
end;

function TTransactionsManager.DeleteTransaction(ATransactionID: Integer): Boolean;
var
  LQuery: TFDQuery;
  LCustomerID: Integer;
  LAmount: Double;
begin
  LQuery := DM.GetQuery(C_SELECT_TRANSACTION_INFO_BY_ID);
  try
    LQuery.ParamByName('PID').AsInteger := ATransactionID;
    LQuery.Open;
    LCustomerID := LQuery.FieldByName('CustomerID').AsInteger;
    LAmount := LQuery.FieldByName('Amount').AsFloat;
    Result := CheckOnRevert(LCustomerID, LAmount);
    if Result then
    begin
      LQuery.SQL.Text := C_DELETE_TRANSACTION;
      LQuery.ParamByName('PID').AsInteger := ATransactionID;
      LQuery.ExecSQL;

      Result := LQuery.RowsAffected > 0;

      if Result then
        CustomersManager.UpdateCustomerCreditLimit(LCustomerID, -LAmount);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTransactionsManager.EditTransaction(ATransactionID: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := DM.GetQuery(C_SELECT_TRANSACTION_INFO_BY_ID);
  try
    LQuery.ParamByName('PID').AsInteger := ATransactionID;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
    begin
      Result := ShowTransactionEdit(LQuery.FieldByName('CustomerID').AsInteger,
        LQuery.FieldByName('Amount').AsFloat, False, ATransactionID);
    end
    else
      Exit(False);
  finally
    LQuery.Free;
  end;
end;

function TTransactionsManager.ShowTransactionEdit(ACustomerID: Integer;
  AAmount: Double; AIsNew: Boolean; AID: Integer): Boolean;
var
  LForm: TfrmEditTransaction;
  LQuery: TFDQuery;
  LCustomerID: Integer;
  LAmount: Double;
  LError: string;
begin
  LForm := TfrmEditTransaction.Create(nil);
  try
    LForm.cbCustomers.EditValue := ACustomerID;
    LForm.edtAmount.Text := AAmount.ToString;
    LForm.StartAmount := AAmount;
    LForm.StartCustomerID := ACustomerID;

    Result := LForm.ShowModal = mrOk;
    if Result then
    begin
      LCustomerID := LForm.cbCustomers.EditValue;
      LAmount := StrToFloat(LForm.edtAmount.Text);

      if not CanAddTransaction(LCustomerID, LAmount, LError) then
      begin
        ShowMessage(LError);
        Exit(False);
      end;

      //if we change customer - check can we revert credit limit
      if not AIsNew then
      begin
        if ACustomerID <> LCustomerID then
        begin
          if not CheckOnRevert(ACustomerID, AAmount) then
            Exit(False);          
        end;
      end;
      
      if AIsNew then
        LQuery := DM.GetQuery(C_INSERT_TRANSACTION)
      else
        LQuery := DM.GetQuery(C_UPDATE_TRANSACTION);
      try
        LQuery.ParamByName('PCustomerID').AsInteger := LCustomerID;
        LQuery.ParamByName('PAmount').AsFloat := LAmount;

        if not AIsNew then
          LQuery.ParamByName('PID').AsInteger := AID
        else
          LQuery.ParamByName('PDate').AsDateTime := Now;

        LQuery.ExecSQL;
      finally
        LQuery.Free;
      end;

      //Revert customer sales, if we change customer in order
      if not AIsNew and (LCustomerID <> ACustomerID) and
        (ACustomerID > -1) and (LCustomerID > -1) then
      begin
        CustomersManager.UpdateCustomerCreditLimit(ACustomerID,
          -AAmount);
      end;

      CustomersManager.UpdateCustomerCreditLimit(LCustomerID, LForm.CustomerAmount);
    end;
  finally
    LForm.Free;
  end;
end;

initialization

finalization
  FreeAndNil(_TransactionManager);

end.
