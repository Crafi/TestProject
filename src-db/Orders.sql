CREATE TABLE Orders (
  ID Integer IDENTITY(1,1) Primary KEY,
  CustomerID Integer,
  Date DateTime,
  Description varchar(100),
  Amount numeric(12,2)
);