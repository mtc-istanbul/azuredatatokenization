--Generate Token for a column 
alter Procedure spTokenGeneratorForColumn
(
    @SchemaName VARCHAR(255) ,
    @TableName VARCHAR(255) ,
@ColumnName VARCHAR(255))
as 
BEGIN

    declare @QueryString VARCHAR(max)
    --Generate query for token generation 
    --new token generated with NEWID() (Guid) simple as random value generation
    --if original value tokenized before ignored. (with not in)
    --only one token per value (with group by )
    set @QueryString = (
    select top 1 
        'insert into tbTokens 
        select ''' + t.SchemaName + ''' ,''' + t.TableName + ''' , '''+ c.ColumnName + ''', 
        ' + c.ColumnName + ' as OriginalValue,
        NEWID() as Token from ' + t.TableName + ' where '  
        + c.ColumnName + ' not in (
            Select OriginalValue from tbTokens where  
                SchemaName = '''+ t.SchemaName + ''' And
                TableName = '''+ t.TableName + ''' and
                ColumnName = '''+ c.ColumnName + '''
        )
        group by ' + c.ColumnName + '
        '
    from 
        tbTableList t 
        inner join tbColumnList c on t.TableName = c.TableName
    where 
        t.SchemaName = @SchemaName 
        and t.TableName = @TableName
        and c.ColumnName = @ColumnName
        and t.MoveToAzure = 1 --table have to be permitted to move Azure
        and c.MoveToAzure = 1 --Column have to be permitted to move Azure
        and c.Tokenize = 1      --Column Havle to be marked as tokenize 
    )
    --if query is empty there is a problem
    if Len (@QueryString) = 0 
    begin
        declare @errorMessage varchar(1000) ='Column Definition not found for  [' + t.SchemaName + '].[' + t.TableName + '].['+ c.ColumnName + ']' 
        Raiserror (@errorMessage, 16,1)
    end
    --Execute query to generate token
    execute (@QueryString)

END