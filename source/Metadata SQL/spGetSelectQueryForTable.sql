--Procedure for get Select query for a table that utilize in Data factory pipeline
--also token generation running

alter Procedure spGetSelectQueryForTable(
    @SchemaName Varchar(255), 
    @TableName Varchar(255)
    )
    as 
    BEGIN

--Return Select query for pipeline
--all tokenize columns have to get from a new join 
select 
' select  ' + STRING_AGG(
     Case when  c.Tokenize  = 1 then 'tokenfor'+c.ColumnName+ '.Token as '+c.ColumnName+ '' else 'o.'+c.ColumnName end 
    , ', ') 

    + ' from ['+ @SchemaName +'].[' + @TableName + '] as o
    
     ' + STRING_AGG( 
     Case when  c.Tokenize  = 1 then '
     left join tbTokens tokenfor'+c.ColumnName+ ' on o.'+c.ColumnName+ ' = tokenfor'+c.ColumnName+ '.OriginalValue and tokenfor'+c.ColumnName+ '.SchemaName = '''+ @SchemaName + ''' and tokenfor'+c.ColumnName+ '.TableName = '''+ @TableName +'''
    ' else '' end 
    , '') 

   as SelectQuery

from tbTableList t 
inner join tbColumnList c on t.TableName = c.TableName and t.SchemaName = c.SchemaName

where t.SchemaName = @SchemaName
    and t.TableName = @TableName
    and t.MoveToAzure = 1
    and c.MoveToAzure = 1 

    END