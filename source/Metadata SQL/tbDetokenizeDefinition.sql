--Detokenize operation definitions stored.

Create Table tbDetokenizeDefinition
(
    SourceFolder Varchar(255), --Source Folder (or Source Table Name )To get Data (assume All sources in same Data Lake)
    TargetTable Varchar(255), --Target Table To Data Land 
    SourceTokenizedColumnName varchar(255), --Tokenized Column Name
    TokenSourceSchemaName VARCHAR(255), --Source Table Schema name for Tokenized Column
    TokenSourceTableName VARCHAR(255),     --Source Table Name for Tokenized Column
    TokenSourceColumnName VARCHAR(255)     --Source Column Name for Tokenized Column
) 