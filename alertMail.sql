--1. configure DB-mail
--run sp_configure to show Database Mail XPs values. need to be 1 to allow for mail
sp_configure

--change to 1
sp_configure 'mail' ,1

--so value changes to 1 also in run_value
reconfigure

--go to management -> database mail -> set up
exec msdb.dbo.sp_send_dbmail @profile_name=Avigail, @recipients='bentovim.avigail@gmail.com',
						@subject='TCDBA24 - homework on alert e-mail - Avigail Ben Tovim',
						@query='select *  from sys.messages where message_id = 50001'

--2. add user error message via sp_add_message

use master
go
exec sp_addmessage 50001, 16, 'Please input a value between 10 and 20'
go

select *
from sys.messages
where message_id = 50001

--3. raise error and send alert by mail

use partitionDB
go
alter procedure raiseMyError (@number int)
as
Begin 

if @number <10 or @number >20 --throw 50001,'',1;
	begin
		exec msdb.dbo.sp_send_dbmail 
		@profile_name=Avigail, 
		@recipients='bentovim.avigail@gmail.com',
		@subject='TCDBA24 - homework on alert e-mail - Avigail Ben Tovim',
		@query='select *  from sys.messages where message_id = 50001'
	end
insert into holidays values (@number);
end 

exec raiseMyError 3


--use msdb
--go
--exec msdb.dbo.sp_send_dbmail 
--		@profile_name=Avigail, 
--		@recipients='bentovim.avigail@gmail.com',
--		@subject='TCDBA24 - homework on alert e-mail - Avigail Ben Tovim',
--		@query='select *  from sys.messages where message_id = 50001'


--		SELECT * FROM sysmail_log
