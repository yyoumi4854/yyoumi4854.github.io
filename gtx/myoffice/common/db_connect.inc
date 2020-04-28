<%
Connect	= "Provider=OraOLEDB.Oracle;Data Source=" & Session("db_home") & ";User ID=" & Session("db_user") & ";Password=" & Session("db_pass") & ";Persist Security Info=True;PLSQLRset=1"
Set DBConn	= Server.CreateObject("ADODB.Connection")
DBConn.Open Connect
%>