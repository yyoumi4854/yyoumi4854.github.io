<%@ CodePage="65001" Language="vbscript"%>
<!-- #include virtual ="/myoffice/common/common.inc" -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
</head>
<%
on Error Resume Next

SET UploadForm = Server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath = server.MapPath ("/board/upload") & "\"

board_id	= UploadForm("board_id")
name		= UploadForm("name")
page		= UploadForm("page")
reg_no		= UploadForm("reg_no")
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

DBConn.BeginTrans
sql =	"Update web_schedule									" &_
		"   set	Subject			= '" & Subject			& "',	" &_
		"		Content			= '" & Content			& "',	" &_
		"		years			= '" & sch_yy			& "',	" &_
		"		moth			= '" & sch_mm			& "',	" &_
		"		days			= '" & sch_dd			& "',	" &_
		"		view_web		= '" & view_web			& "',	" &_
		"		repeat_yn		= '" & repeat_yn		& "',	" &_
		"		repeat_start	= '" & repeat_start		& "',	" &_
		"		repeat_end		= '" & repeat_end		& "',	" &_
		"		update_date		=  " & "sysdate"		& ",	" &_
		"		update_user		= '" & work_user		& "'	" &_
		" where	reg_no			= "	 & reg_no
DBConn.Execute(sql)

If DBConn.Errors.Count = 0 Then
	DBConn.CommitTrans

	url = "location.href = './schedule_list.asp?page=" & page & "';"
	Response.Write "<script language=javascript>"
	Response.Write "	alert('일정 수정이 완료되었습니다.');"
	Response.Write url
	Response.Write "</script>"
Else
	DBConn.RollBackTrans

	msg = err.description : msg = replace(msg,"'","")

	Response.Write "<script language=javascript>"
	Response.Write "	alert('일정 수정에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
	Response.Write "	history.back();"
	Response.Write "</script>"
End If
%>
