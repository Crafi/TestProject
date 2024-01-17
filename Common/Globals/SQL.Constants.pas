unit SQL.Constants;

interface

const
  CR = #13;
  LF = #10;
  CRLF = CR + LF;

{$Region 'Customers'}
  C_SELECT_CUSTOMERS = 'SELECT Customers.*, (CreditLimit - SalesVolume) AS Balance FROM Customers' + CRLF +
    'ORDER BY ID';
  C_INSERT_CUSTOMER = 'INSERT INTO Customers' + CRLF +
    '(Code, Name, Address, VATNumber)' + CRLF +
    'VALUES (:PCode, :PName, :PAddress, :PVATNumber)';
  C_UPDATE_CUSTOMER = 'UPDATE Customers SET' + CRLF +
    'Code = :PCode,' + CRLF +
    'Name = :PName,' + CRLF +
    'Address = :PAddress,' + CRLF +
    'VATNumber = :PVATNumber,' + CRLF +
    'WHERE ID = :PID';
  C_UPDATE_CUSTOMER_SALES_VOLUME_BY_ID = 'UPDATE Customers SET' + CRLF +
    'SalesVolume = SalesVolume + :PSalesVolume' + CRLF +
    'WHERE ID = :PID';
  C_UPDATE_CUSTOMER_CREDIT_LIMIT_BY_ID = 'UPDATE Customers SET' + CRLF +
    'CreditLimit = CreditLimit + :PCreditLimit' + CRLF +
    'WHERE ID = :PID';
  C_DELETE_CUSTOMER = 'DELETE FROM Customers WHERE ID = :PID';
  C_CUSTOMER_CONDITION_EDIT = ' AND ID <> :PID';
  C_FIND_CUSTOMER_BY_CODE = 'SELECT * FROM Customers WHERE Code = :PCode';
  C_FIND_CUSTOMER_BY_CODE_EDIT = C_FIND_CUSTOMER_BY_CODE + C_CUSTOMER_CONDITION_EDIT;
  C_FIND_CUSTOMER_BY_VAT_NUMBER = 'SELECT * FROM Customers WHERE VATNumber = :PVATNumber';
  C_FIND_CUSTOMER_BY_VAT_NUMBER_EDIT = C_FIND_CUSTOMER_BY_VAT_NUMBER + C_CUSTOMER_CONDITION_EDIT;
  C_SELECT_CUSTOMER_BY_ID = 'SELECT * FROM Customers WHERE ID = :PID';
  C_SELECT_CUSTOMER_BALANCE_BY_ID = 'SELECT (CreditLimit - SalesVolume) AS Balance FROM Customers WHERE ID = :PID';
  C_SELECT_CUSTOMER_BY_CODE = 'SELECT * FROM Customers WHERE Code = :PCode';
{$EndRegion}

{$Region 'Orders'}
  C_SELECT_ORDERS = 'SELECT Orders.*,' + CRLF +
    'Customers.Name AS CustomerName, Customers.Code AS CustomerCode' + CRLF +
    'FROM Orders' + CRLF +
    'INNER JOIN Customers ON Orders.CustomerID = Customers.ID' + CRLF +
    'ORDER BY ID';
  C_SELECT_ORDER_INFO_BY_ID = 'SELECT Amount, CustomerID, Description FROM Orders WHERE ID = :PID';
  C_INSERT_ORDER = 'INSERT INTO Orders' + CRLF +
    '(CustomerID, Date, Description, Amount)' + CRLF +
    'VALUES (:PCustomerID, :PDate, :PDescription, :PAmount)';
  C_UPDATE_ORDER = 'UPDATE Orders SET' + CRLF +
    'CustomerID = :PCustomerID,' + CRLF +
    'Description = :PDescription,' + CRLF +
    'Amount = :PAmount' + CRLF +
    'WHERE ID = :PID';
  C_DELETE_ORDER = 'DELETE FROM Orders WHERE ID = :PID';
  C_SELECT_ORDERS_BY_CUSTOMER = 'SELECT Count(*) AS Count FROM Orders WHERE ID = :PID';
{$EndRegion}

{$Region 'Transactions'}
  C_SELECT_TRANSACTIONS = 'SELECT Transactions.*,' + CRLF +
    'Customers.Name AS CustomerName, Customers.Code AS CustomerCode' + CRLF +
    'FROM Transactions' + CRLF +
    'INNER JOIN Customers ON Transactions.CustomerID = Customers.ID' + CRLF +
    'ORDER BY ID';
  C_SELECT_TRANSACTION_INFO_BY_ID = 'SELECT CustomerID, Amount FROM Transactions' + CRLF +
    'WHERE ID = :PID';
  C_INSERT_TRANSACTION = 'INSERT INTO Transactions' + CRLF +
    '(CustomerID, Date, Amount)' + CRLF +
    'VALUES (:PCustomerID, :PDate, :PAmount)';
  C_UPDATE_TRANSACTION = 'UPDATE Transactions SET' + CRLF +
    'CustomerID = :PCustomerID,' + CRLF +
    'Amount = :PAmount' + CRLF +
    'WHERE ID = :PID';
  C_DELETE_TRANSACTION = 'DELETE Transactions WHERE ID = :PID';
  C_SELECT_TRANSACTIONS_BY_CUSTOMER = 'SELECT Count(*) AS Count FROM Transactions WHERE ID = :PID';
{$EndRegion}

{$Region 'Reports'}
  C_ORDERS_REPORT_DATE = 'SELECT Orders.*,' + CRLF +
    'Customers.Name AS CustomerName, Customers.Code AS CustomerCode' + CRLF +
    'FROM Orders' + CRLF +
    'INNER JOIN Customers ON Customers.ID = Orders.CustomerID' + CRLF +
    'WHERE Date BETWEEN :PDateFrom AND :PDateTo';
  C_ORDERS_REPORT_DATE_CUSTOMER = C_ORDERS_REPORT_DATE + CRLF +
    'AND CustomerID = :PCustomerID';
{$EndRegion}

implementation

end.
