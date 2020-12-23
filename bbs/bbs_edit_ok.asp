<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual="/myoffice/common/bbs_common.inc" -->
<!-- #include file="./freeaspupload.html" -->
<%
On Error Resume Next

Err_Msg				= "OK"
go_upload			= "T"

'====================파일 업로드 부분 ===========================
  Dim uploadsDirVar
  Dim Upload, fileName, fileSize, ks, i, fileKey,webPath,fileIndex,arrFileName
  webPath = "/bbs/upload"
  uploadsDirVar =  Server.mappath(webPath)
  Set Upload = New FreeASPUpload
  Upload.Save(uploadsDirVar) '파일 업로드

	ks = Upload.UploadedFiles.keys
	if (UBound(ks) <> -1) Then
		redim arrFileName(UBound(ks))
		fileIndex=0
		for each fileKey in Upload.UploadedFiles.keys
			arrFileName(fileIndex) = webPath &"/"& Upload.UploadedFiles(fileKey).FileName 	'파일명 가져옴
			fileIndex=fileIndex+1
		Next
	end If
'====================파일 업로드 부분 =============================

If go_upload = "F" Then

	Response.Write "<script language='javascript'>"
	Response.Write "	alert('" & Err_Msg & "');"
	Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
	Response.Write "</script>"

	Set Upload = Nothing
	Response.End

Else

	bbs_kind	= TRIM(Upload.Form("bbs_kind"))
	sid			= TRIM(Upload.Form("sid"))
	update_user	= TRIM(Upload.Form("update_user"))
	ip_addr		= TRIM(Upload.Form("ip_addr"))
	link_query	= TRIM(Upload.Form("link_query"))

	userid		= TRIM(Upload.Form("userid"))
	username	= TRIM(Upload.Form("username"))
	view_target	= TRIM(Upload.Form("view_target"))	: If view_target	= ""	Then view_target = "0"
	status		= TRIM(Upload.Form("status"))			: If status			= ""	Then status		 = "1"
	bbs_cate	= TRIM(Upload.Form("bbs_cate"))		: If bbs_cate		= ""	Then bbs_cate	 = "-"
	st_date		= TRIM(Upload.Form("st_date"))		: If st_date		= ""	Then st_date	 = TRIM(Upload.Form("old_st_date"))
	ed_date		= TRIM(Upload.Form("ed_date"))		: If ed_date		= ""	Then ed_date	 = TRIM(Upload.Form("old_ed_date"))
	time_limit	= "0"							: If ed_date <> "3000-12-31" Then time_limit = "1"
	foreword	= TRIM(Upload.Form("foreword"))
	subject		= TRIM(Upload.Form("Subject"))
	content		= Upload.Form("msg_body")
	content		= Replace(Replace(content, """", "&#34;"), "'","&#39;")
	answer_content	= Upload.Form("msg_body2")
	answer_content	= Replace(Replace(answer_content, """", "&#34;"), "'","&#39;")

	answer_status	= TRIM(Upload.Form("answer_status"))
	passwd		= TRIM(Upload.Form("passwd"))
	email		= TRIM(Upload.Form("email"))

	top_noti	= TRIM(Upload.Form("top_noti"))		: If top_noti	= ""	Then top_noti = "0"
	isSecret	= TRIM(Upload.Form("isSecret"))		: If isSecret	= ""	Then isSecret = "0"

	old_upfile	= TRIM(Upload.Form("old_upfile"))
	file1_del	= TRIM(Upload.Form("file1_del"))		: If file1_del	= ""	Then file1_del = "0"


'====파일 관련 처리
Dim oldFileName(1),FileDel(1)
oldFileName(0)	= old_upfile
FileDel(0)		= file1_del
nFileCount = 1

ks = Upload.UploadedFiles.keys
if (UBound(ks) <> -1) Then
	redim arrFileName(UBound(ks))
	fileIndex=0
	for each fileKey in Upload.UploadedFiles.keys
		arrFileName(fileIndex) = webPath &"/"& Upload.UploadedFiles(fileKey).FileName 	'파일명 가져옴
		Response.Write arrFileName(fileIndex)
		fileIndex=fileIndex+1
	Next
Else
	ReDim arrFileName(1)

end If

'파일 삭제 처리
For f_cnt = 0 To nFileCount-1
	If (UBound(ks) = -1) Then
		If FileDel(f_cnt) = "1" Then
			arrFileName(f_cnt) = ""
		Else
			arrFileName(f_cnt) = oldFileName(f_cnt)
		End If
	End If
Next

	check_str	= bbs_kind & userid & username & st_date & ed_date & foreword & subject  & passwd & email

	If check_injection(check_str) <> "OK" Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('특수문자나 명령어는 입력하실 수 없습니다.');"
		Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
		Response.Write "</script>"
		Response.End
	Else

		DBConn.BeginTrans

		sql =		"update Web_BBS									"
		sql = sql & "   set	target		= '" & view_target	& "',	"
		sql = sql & "		status		= '" & status		& "',	"


		sql = sql & "		bbs_cate	= '" & bbs_cate		& "',	"
		sql = sql & "		userid		= '" & userid		& "',	"
		sql = sql & "		username	= '" & username		& "',	"
		sql = sql & "		isSecret	= '" & isSecret		& "',	"
		sql = sql & "		passwd		= '" & passwd		& "',	"
		sql = sql & "		time_limit	= '" & time_limit	& "',	"
		sql = sql & "		st_date		= '" & st_date		& "',	"
		sql = sql & "		ed_date		= '" & ed_date		& "',	"
		sql = sql & "		foreword	= '" & foreword		& "',	"
		sql = sql & "		subject		= '" & subject		& "',	"
		'sql = sql & "		content		= '"& "empty_clob()"& "',	"
		sql = sql & "		email		= '" & email		& "',	"
		sql = sql & "		top_noti	= '" & top_noti		& "',	"
		sql = sql & "		answer_status	= '" & answer_status		& "',	"


		For f_cnt = 1 To nFileCount
		sql = sql & "		file" & f_cnt & "_name	= '" & arrFileName(f_cnt-1)	& "',	"
		Next

'		For f_cnt = nFileCount+1 To 5
'		sql = sql & "		file" & f_cnt & "_name	= '" & ""					& "',	"
'		Next

		sql = sql & "		ip_addr		= '" & ip_addr		& "',	"
		sql = sql & "		update_user	= '" & update_user	& "',	"
		sql = sql & "		update_date	= sysdate					"
		sql = sql & " where	sid			=  " & sid

		DBConn.Execute(sql)

		If top_noti > "1" Then
			sql = "update web_bbs set top_noti = '0' where top_noti = '" & top_noti & "' and sid <> " & sid
			DBConn.Execute(sql)
		End If

		If DBConn.Errors.Count = 0 Then

			DBConn.CommitTrans
			Set rs_update = Server.CreateObject("ADODB.RecordSet")
				rs_update.open "select content from web_bbs where sid = " & sid, DBConn, 3,3
				rs_update.fields("content").appendChunk(content)
				rs_update.update
				rs_update.Close

			Set rs_update2 = Server.CreateObject("ADODB.RecordSet")
				rs_update2.open "select answer_content from web_bbs where sid = " & sid, DBConn, 3,3
				rs_update2.fields("answer_content").appendChunk(answer_content)
				rs_update2.update
				rs_update2.Close




			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 수정이 완료되었습니다.');"


			If Session("admin") <> "" Then
			Response.Write "	parent.location.href = './bbs_view.asp?" & link_query & "&sid=" & sid & "';"
			Else
			Response.Write "	parent.location.href = './bbs_resp_view.asp?" & link_query & "&sid=" & sid & "';"

			End If

			Response.Write "</script>"
		Else
			DBConn.RollBackTrans

			msg = err.description : msg = replace(msg,"'","")

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 수정에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
			Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
		End If
	End If

	Set Upload = Nothing

End If

Function ext_check(ByVal f_name)
	acc_ext = "JPG|JPEG|GIF|BMP|PNG|XLS|XLSX|DOC|DOCX|PPT|PPTX|HWP|TXT|PDF"
	arr_ext = Split(acc_ext,"|")
	f_ext	= UCase(Right(f_name,Len(f_name)-InstrRev(f_name,".")))

	match_cnt = 0

	For fI=0 To UBound(arr_ext)
		IF f_ext = arr_ext(fI) Then match_cnt = match_cnt + 1
	Next

	If match_cnt = 0 Then
		ext_check = "F:FAIL"
	Else
		Select Case f_ext
			Case "JPG","JPEG","GIF","BMP","PNG"	: ext_check = "T:IMG"
			Case Else							: ext_check = "T:DOC"
		End Select
	End If
End Function
%>


