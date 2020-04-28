<!--#include virtual="/myoffice/common/common.inc"-->
<%
If check_injection("") <> "OK" Then
	Response.Write "<script language='javascript'>"
	Response.Write "	alert('특수문자나 예약명령어는 사용하실 수 없습니다.');"
	Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
	Response.Write "</script>"
	Response.End
End If

login_id	= Request.Form("login_id")
passwd		= Request.Form("passwd")

sql =		"select	userid, username, admin_lv	"
sql = sql & "  from	web_admin					"
sql = sql & " where	userid = '" & login_id	& "'"
sql = sql & "   and	passwd = '" & passwd	& "'"
Set rs = DBConn.Execute(sql)

If Not rs.eof Then

	Session("admin")		= rs("userid")
	Session("admin_name")	= rs("username")
	Session("admin_lv")		= rs("admin_lv")
'관리계정으로 홈페이지 로그인.
	session("userid")	= rs("userid")
	session("username")	= rs("username")
	session("login_id")	= rs("userid")

	session("REQ_SEQ")  = rs("userid")
	'session("user_kind")	= InitGrade
	'session("center_cd")	= center


	Response.Write "<script language='javascript'>"
	Response.Write "	parent.location.href = './admin_frame.asp';"
	Response.Write "</script>"

Else
	msg =		"▶ 로그인 실패"														& "\n"
	msg = msg & "------------------------------------------------------------------"	& "\n"
	msg = msg & "입력하신 정보에 해당하는 관리자가 존재하지 않습니다."

	Response.Write "<script language='javascript'>"
	Response.Write "	alert('" & msg & "');"
	Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
	Response.Write "</script>"
End If

rs.Close : Set rs = Nothing
%>

<!--#include virtual="/myoffice/common/db_close.inc"-->