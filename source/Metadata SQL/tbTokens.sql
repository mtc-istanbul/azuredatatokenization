--Table for storage token value pairs by table

Create Table tbTokens
(

    SchemaName VARCHAR(255), --Source Table Schema name
    TableName VARCHAR(255),     --Source Table Name
    ColumnName VARCHAR(255),    --Source Column Name
    OriginalValue Varchar(255), --Source data original value
    Token Varchar(255)          --Generated Token for Original value (per value)
)

create clustered index ix_token on tbTokens (                 OriginalValue, SchemaName , TableName ,  ColumnName) 