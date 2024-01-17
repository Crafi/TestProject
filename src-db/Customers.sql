CREATE TABLE CUSTOMERS (
  ID Integer IDENTITY(1,1) Primary KEY, 
  Code Integer, 
  Name varchar(100),
  Address varchar(100),
  VATNumber varchar(11),
  CreditLimit numeric(12,2) DEFAULT 0,
  SalesVolume numeric(12,2) DEFAULT 0
);