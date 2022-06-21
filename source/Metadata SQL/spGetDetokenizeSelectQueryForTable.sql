--Procedure for get Detokenize Select query for a table that utilize in Data factory pipeline
 

alter Procedure spGetDetokenizeSelectQueryForTable(
    @TableName Varchar(255)
    )
    as 
    BEGIN
 
--Return Select query for pipeline
--all tokenize columns have to get from a new join 
select 
' insert into ['+@TableName+'] (
     ' + STRING_AGG(c.Name , ', ') + '
)
 select  ' + STRING_AGG(
     Case when  dcd.SourceTokenizedColumnName is not null then 
            'tokenfor'+dcd.TokenSourceColumnName + '.OriginalValue as '+dcd.TokenSourceColumnName + '' 
     else 'o.'+c.Name end 
    , ', ') 

    + ' from ['+@TableName+'_Temporary] as o
    
     ' + STRING_AGG( 
     Case when  dcd.SourceTokenizedColumnName is not null then '
     left join tbTokens tokenfor'+dcd.TokenSourceColumnName + ' on 
                o.'+dcd.TokenSourceColumnName + ' = tokenfor'+dcd.TokenSourceColumnName + '.Token and 
                tokenfor'+dcd.TokenSourceColumnName + '.SchemaName = '''+ dcd.TokenSourceSchemaName + ''' and 
                tokenfor'+dcd.TokenSourceColumnName + '.TableName = '''+ dcd.TokenSourceTableName +'''and 
                tokenfor'+dcd.TokenSourceColumnName + '.ColumnName = '''+ dcd.TokenSourceColumnName +'''
    ' else '' end 
    , '') 

   as SelectQuery

 
from (select distinct  TargetTable ,  TokenSourceSchemaName  ,  TokenSourceTableName  from tbDetokenizeDefinition where TargetTable = @TableName)   dt 
 inner join sys.tables t on t.name = dt.TargetTable
 inner join sys.columns c on c.object_id = t.object_id  
left join tbDetokenizeDefinition dcd on dcd.TargetTable =dt.TargetTable and dcd.SourceTokenizedColumnName = c.name

where  
     dt.TargetTable = @TableName
 

    END