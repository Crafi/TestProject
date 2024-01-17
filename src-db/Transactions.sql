CREATE TABLE Transactions(
  ID Integer IDENTITY(1,1) Primary KEY,
  CustomerID Integer,
  Date DateTime,
  Amount numeric(12,2)
);