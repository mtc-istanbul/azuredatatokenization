--Procedure for get Select query for a table that utilize in Data factory pipeline
--also token generation running

alter Procedure spGenerateMissedTokenForTable(
    @SchemaName Varchar(255), 
    @TableName Varchar(255)
    )
    as 
    BEGIN
--Generate Token for all values if not exist
EXECUTE spTokenGeneratorForTable @SchemaName = @SchemaName, @TableName = @TableName
 
    END