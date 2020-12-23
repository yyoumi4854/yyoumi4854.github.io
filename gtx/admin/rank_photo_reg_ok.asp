<%@ CodePage="65001" Language="vbscript"%>
<!-- #include virtual ="/myoffice/common/common.inc" -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
</head>
<%
On Error Resume Next
SET UploadForm = Server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath = server.MapPath ("/board/upload/rank_photo") & "\"

mode		= UploadForm("mode")
userid		= UploadForm("userid")
username	= UploadForm("username")
rank_cd		= UploadForm("rank_cd")
rank_name	= UploadForm("rank_name")
rank_month	= UploadForm("rank_month")
work_user	= UploadForm("work_user")
page_str	= UploadForm("page_str")			: page_str = Replace(page_str,"$","&")
filename1	= UploadForm("filename1").FileName

IF filename1 <> "" THEN

	M_CHK	= UCase(Right(filename1,Len(filename1)-InStrRev(filename1,".")))
	Ext_Chk	= MIME_CHK(M_CHK)

	IF Ext_Chk = "T" THEN
		UploadForm("filename1").Save
		photo = UploadForm("filename1").LastSavedFileName
	Else
		response.write "<script language=javascript>"
		Response.write "alert('업로드할 수 없는 파일입니다.');"
		Response.Write "history.back();"
		Response.Write "</script>"
		Response.End
	End If
End If

If mode = "NEW" Then
	set rs = server.createobject("adodb.recordset")
	sql	= "select nvl(max(reg_no),0)+1 from web_rankup "
	rs.open sql, dbconn
		new_reg = rs(0)
	rs.close : Set rs = Nothing

	DBConn.BeginTrans
	sql =	"insert into web_rankup (							" &_
			"	reg_no, userid, username, rank_cd, rank_name,	" &_
			"	rank_month, photo, work_user, work_date			" &_
			")													" &_
			"values(											" &_
			""	& new_reg		& ",							" &_
			"'"	& userid		& "',							" &_
			"'"	& username		& "',							" &_
			""	& rank_cd		& ",							" &_
			"'"	& rank_name		& "',							" &_
			"'"	& rank_month	& "',							" &_
			"'"	& photo			& "',							" &_
			"'"	& work_user		& "',							" &_
			""	& "sysdate"		& ")							"
	DBConn.Execute(sql)

	ret_msg = "사진 등록이"

ElseIf mode = "MOD" Then

	DBConn.BeginTrans
	sql =		"update	web_rankup								"
	sql = sql & "   set	photo		= '" & photo		& "'	"
	sql = sql & " where	userid		= '" & userid		& "'	"
	sql = sql & "   and	rank_month	= '" & rank_month	& "'	"
	sql = sql & "   and	rank_cd		=  " & rank_cd
	DBConn.Execute(sql)

	ret_msg = "사진 교체가"
End If

If DBConn.Errors.Count = 0 Then
	DBConn.CommitTrans

	url = "opener.location.href = './rankup_list.asp?" & page_str & "';"

	Response.Write "<script language=javascript>"
	Response.Write "	alert('" & ret_msg & " 완료되었습니다.');"
	Response.Write url
	Response.Write "	window.close();"
	Response.Write "</script>"
Else
	DBConn.RollBackTrans

	msg = err.description : msg = replace(msg,"'","")

	Response.Write "<script language=javascript>"
	Response.Write "	alert('" & ret_msg & " 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
	Response.Write "	history.back();"
	Response.Write "</script>"
End If

Function MIME_CHK(ext)
	acc_ext = "JPG|JPEG|GIF|BMP|PNG|XLX|DOC|DOCX|XLSX|DOC|HWP|TXT|PPT|PPTX|PDF|XLS|AVI|WMV|MOV"
	arr_ext = Split(acc_ext,"|")

	match_cnt = 0

	For I=0 To UBound(arr_ext)
		IF ext = arr_ext(I) Then match_cnt = match_cnt + 1
	Next

	IF match_cnt = 0 THEN
		Mime_CHK = "F"
	ELSE
		Mime_CHK = "T"
	END IF
End Function

Set UploadForm	= Nothing
%>
