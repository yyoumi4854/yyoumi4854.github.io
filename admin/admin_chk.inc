<%
if session("admin") = "" Or board_id <> "QNA" then
	session.abandon
	response.write "<script language='javascript'> "
	response.write "alert('로그인을 하셔야 이용이 가능합니다.'); "
	response.write "top.parent.location.href='/admin/index.asp?chk=n'; "
	response.write "</script>"
	response.end
end if
%>