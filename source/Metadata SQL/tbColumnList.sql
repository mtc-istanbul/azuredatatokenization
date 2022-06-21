--Column list to move Azure permission and Tokinizing info
Create Table tbColumnList
(
   SchemaName VARCHAR(255), --Source Table Schema name
    TableName VARCHAR(255),     --Source Table Name
    ColumnName VARCHAR(255),    --Source Column Name
    MoveToAzure bit,            --Permission to move Azure if Permittied Value is 1 is not permitted Value is 0 and this column not to move Azure Side 
    Tokenize bit                --for permitted columns Tokenizing mark if 1 column have to be tokenize before move azure, else for 0 column move to azure as is
)