--Procedure to get list of table that approved table list for tokenize

Create Procedure spGetTokenizeTableList
as 
Select distinct SchemaName, TableName from tbTableList where 
MoveToAzure = 1