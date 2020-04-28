<%@ CodePage="65001" Language="vbscript"%>
<!-- #include virtual ="/myoffice/common/common.inc" -->

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
</head>
<%
on Error Resume Next
SET UploadForm = Server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath = server.MapPath ("/bbs/upload") & "\"

board_id	= UploadForm("board_id")
name		= UploadForm("name")

subject		= UploadForm("subject")
sch_yy		= UploadForm("sch_yy")
sch_mm		= UploadForm("sch_mm")
sch_dd		= UploadForm("sch_dd")
view_web	= UploadForm("view_web")
repeat_yn	= UploadForm("repeat_yn")
re_start_yy	= UploadForm("re_start_yy")
re_start_mm	= UploadForm("re_start_mm")
If re_start_yy <> "" And re_start_mm <> "" Then	repeat_start = re_start_yy & "-" & re_start_mm
re_end_yy	= UploadForm("re_end_yy")
re_end_mm	= UploadForm("re_end_mm")
If re_end_yy <> "" And re_end_mm <> "" Then	repeat_end = re_end_yy & "-" & re_end_mm

If repeat_yn = "0" Then
	repeat_start = ""
	repeat_end	 = ""
End If

content		= UploadForm("content")
work_user	= UploadForm("work_user")

set rs = server.createobject("adodb.recordset")
sql	= "select nvl(max(reg_no),0)+1 from web_schedule "
rs.open sql, dbconn
	new_reg = rs(0)
rs.close : Set rs = Nothing

DBConn.BeginTrans
sql =	"insert into web_schedule (							" &_
		"	reg_no, years, moth, days, subject, content,	" &_
		"	view_web, repeat_yn, repeat_start, repeat_end,	" &_
		"	work_user, reg_date			 					" &_
		")													" &_
		"values(											" &_
		""	& new_reg		& ",							" &_
		"'"	& sch_yy		& "',							" &_
		"'"	& sch_mm		& "',							" &_
		"'"	& sch_dd		& "',							" &_
		"'"	& subject		& "',							" &_
		"'"	& content		& "',							" &_
		"'"	& view_web		& "',							" &_
		"'"	& repeat_yn		& "',							" &_
		"'"	& repeat_start	& "',							" &_
		"'"	& repeat_end	& "',							" &_
		"'"	& work_user		& "',							" &_
		""	& "sysdate"		& ")							"
DBConn.Execute(sql)

If DBConn.Errors.Count = 0 Then
	DBConn.CommitTrans

	url = "location.href = './schedule_list.asp';"

	Response.Write "<script language=javascript>"
	Response.Write "	alert('일정 등록이 완료되었습니다.');"
	Response.Write url
	Response.Write "</script>"
Else
	DBConn.RollBackTrans

	msg = err.description : msg = replace(msg,"'","")

	Response.Write "<script language=javascript>"
	Response.Write "	alert('일정 등록에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
	Response.Write "	history.back();"
	Response.Write "</script>"
End If
%>
