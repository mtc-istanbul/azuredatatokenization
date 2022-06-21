--cleanup all demo data from source side include

--truncate all definition tables.
--truncate existing tokens
--Usage 
--spResetDemoSourceEnvironment @AreYouSure = 'Yes'

create procedure spResetDemoSourceEnvironment
(@AreYouSure varchar(255)
)
as 
begin 

    if (@AreYouSure <> 'Yes')
    RETURN

truncate table tbTableList
truncate table tbColumnList
truncate table tbTokens


select SCHEMA_NAME(schema_id) as SchemaName, t.name as TableName, c.name as ColumnName
into #tmpbusinessTableDefinitions from sys.tables t 
inner join sys.columns c on c.object_id = t.object_id
 where  
t.name not in ('tbApprove', 
'tbApproveRequestDetail',
'tbColumnList',
'tbDetokenizeDefinition',
'tbTableList',
'tbTokens'
)

insert into tbTableList
select distinct SchemaName, TableName, 0 as MoveToAzure from #tmpbusinessTableDefinitions

insert into tbColumnList 
select distinct SchemaName, TableName, ColumnName,  0 as MoveToAzure, 0 as Tokenize from #tmpbusinessTableDefinitions


END