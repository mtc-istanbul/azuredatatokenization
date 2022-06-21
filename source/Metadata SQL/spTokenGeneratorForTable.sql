--Token Generation for a tables all needed columns

alter Procedure spTokenGeneratorForTable
(
    @SchemaName VARCHAR(255) ,
    @TableName VARCHAR(255)  )
as 
BEGIN

    declare @ColumnName VARCHAR(255);

    create Table   #columnList (columnName VARCHAR(255) , SequenceNumber int );
--Get all columns needs to tokenize 
    insert into #columnList 
        Select c.ColumnName , ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS SequenceNumber 
                    from tbTableList t 
                    inner join tbColumnList c on t.TableName = c.TableName
                    where t.SchemaName = @SchemaName
                        and t.TableName = @TableName
                        and t.MoveToAzure = 1
                        and c.MoveToAzure = 1 
                        and c.Tokenize = 1;
--take first one
    set @ColumnName = (select top 1 columnName from #columnList order by columnName asc );

    
    while @ColumnName is not null
    BEGIN
    --trigger tokenizing for a column
        execute spTokenGeneratorForColumn 
                   @SchemaName = @SchemaName ,  @TableName = @TableName, @ColumnName = @ColumnName;

--pick next column
        set @ColumnName = (select top 1 columnName from #columnList where columnName > @ColumnName order by columnName asc );

    end
    drop table  #columnList
END