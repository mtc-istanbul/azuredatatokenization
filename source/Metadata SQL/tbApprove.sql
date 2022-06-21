 
Create Table tbApprove
(
   ApproveRequestId int Identity(1,1),
   RequestDate Datetime,
   ApproveDate Datetime,
   Approver Varchar(255),
   Requestor Varchar(255),
   ApproveStatus Varchar(255)
)