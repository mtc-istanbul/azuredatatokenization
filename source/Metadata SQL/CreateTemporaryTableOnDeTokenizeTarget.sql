--this procedure create a temporary (staging Table) with TargetStructure
--its needed for detokenize operations.
--tokens and equivalent original varlues stay on on-premise side.
--we have to transfer tokenized data near tokens after than join them to detokinze 

Create Procedure CreateTemporaryTableOnDeTokenizeTarget 
(@TargetTableName Varchar(255))
as 

declare @createQuery Varchar(max)

if Exists (select 1 from sys.tables where name = @TargetTableName +'_Temporary')
begin
    set @createQuery = 'Drop Table '+ @TargetTableName +'_Temporary'
    execute (@createQuery)
end

set @createQuery = (
Select 
CreateQuery =	'Create table ' + t.name   +'_Temporary' +  
' ('  + STRING_AGG(Convert(nvarchar(max), c.name collate SQL_Latin1_General_CP1254_CI_AS+ ' ' + 
ty.name collate SQL_Latin1_General_CP1254_CI_AS + case when ty.name collate SQL_Latin1_General_CP1254_CI_AS = 'varchar' then  '('+  convert(varchar, c.max_length ) + ')' else '' end) , ' , ' ) + ' ) '  

from sys.tables t 
inner join sys.columns c on t.object_id = c.object_id
inner join sys.types ty on ty.user_type_id =c.user_type_id
where t.name =@TargetTableName
group by t.name)

execute (@createQuery)