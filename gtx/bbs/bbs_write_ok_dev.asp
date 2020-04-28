<!-- #include virtual ="/common/common.inc" -->
<!-- #include virtual="/common/bbs_common.inc" -->
<!-- #include file="./freeaspupload_unique.html" -->
<%


'On Error Resume Next

'Set oDext = Server.CreateObject("DEXT.FileUpload")
'oDext.DefaultPath	= Server.MapPath("\bbs\upload")
'oDext.MaxFileLen	= maxSize
'
'Err_Msg				= "OK"
'go_upload			= "T"
'
'Dim arrFileName()
'nFileCount = oDext("upfile").count
'Redim arrFileName(nFileCount)
'
'If Err.Number <> 0 Then
'	go_upload	= "F"
'	Err_Msg		= "해당 파일을 삽입할 수 없습니다\n이미지의 저장포맷에 문제가 있습니다.\nALSee, AcdSee등을 이용하여 포맷변환해 주십시오."
'	Err_Msg		= Err.Description
'Else
'
'	For f_cnt = 1 To nFileCount
'
'		FILE_NAME	= oDext("upfile")(f_cnt).FileName
'		FILE_LEN	= oDext("upfile")(f_cnt).FileLen
'		FILE_WIDTH	= oDext("upfile")(f_cnt).ImageWidth
'
'		If FILE_NAME <> "" Then
'
'			check_extention = ext_check(FILE_NAME)
'			ext_ok			= Split(check_extention,":")(0)
'			ext_type		= Split(check_extention,":")(1)
'
'			If FILE_LEN > maxSize Then
'				go_upload	= "F"
'				Err_Msg		= (maxSize / 1024 / 1024) & "M 보다 큰 용량은 올리실 수 없습니다.\n첨부파일의 크기를 확인해주십시오."
'			ElseIf ext_ok = "F" Then
'				go_upload	= "F"
'				Err_Msg		= "해당 파일형식은 업로드하실 수 없습니다.\n이미지 또는 문서파일만 업로드 가능합니다."
'			ElseIf (FILE_WIDTH > LimitWidth) Then
'				go_upload	= "F"
'				Err_Msg		= "이미지의 가로크기가 " & LimitWidth & "px 보다 큽니다.\n이미지의 크기를 조절해주십시오."
'			End If
'
'			If go_upload = "F" Then
'				oDext.Flush
'				Exit For
'			Else
'				FULL_PATH			= oDext.DefaultPath & "\" & FILE_NAME
'				uploadedfile		= oDext.SaveAs(FULL_PATH, False)
'				arrFileName(f_cnt)	= "/bbs/upload/" & oDext.LastSavedFileName
'			End If
'		End If
'	Next
'
'End If

'====================파일 업로드 부분 ===========================
  Dim uploadsDirVar
  Dim Upload, fileName, fileSize, ks, i, fileKey,webPath,fileIndex,arrFileName
  webPath ="\bbs\upload"
  uploadsDirVar =  Server.mappath(webPath)
  Set Upload = New FreeASPUpload
  Upload.Save(uploadsDirVar) '파일 업로드

	ks = Upload.UploadedFiles.keys
	if (UBound(ks) <> -1) Then
		redim arrFileName(UBound(ks))
		fileIndex=0
		for each fileKey in Upload.UploadedFiles.keys
			arrFileName(fileIndex) = webPath &"/"& Upload.UploadedFiles(fileKey).FileName 	'파일명 가져옴
			'arrFileName(fileIndex) = webPath &"/"& Session("refilename") 	'파일명 가져옴
			fileIndex=fileIndex+1
		Next
	end If
'====================파일 업로드 부분 =============================
Response.End
If go_upload = "F" Then

	oDext.Flush
	Response.Write "<script language='javascript'>"
	Response.Write "	alert('" & Err_Msg & "');"
	Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
	Response.Write "</script>"

'	Set oDext = Nothing
	Response.End

Else

'	bbs_kind	= TRIM(oDext("bbs_kind"))
'	ip_addr		= TRIM(oDext("ip_addr"))
'	userid		= TRIM(oDext("userid"))
'	username	= TRIM(oDext("username"))
'	view_target	= TRIM(oDext("view_target"))	: If view_target	= ""	Then view_target = "0"
'	status		= TRIM(oDext("status"))			: If status			= ""	Then status		 = "1"
'	bbs_cate	= TRIM(oDext("bbs_cate"))		: If bbs_cate		= ""	Then bbs_cate	 = "-"
'	st_date		= TRIM(oDext("st_date"))		: If st_date		= ""	Then st_date	 = Date
'	ed_date		= TRIM(oDext("ed_date"))		: If ed_date		= ""	Then ed_date	 = "3000-12-31"
'	time_limit	= "0"							: If ed_date <> "3000-12-31" Then time_limit = "1"
'	foreword	= TRIM(oDext("foreword"))
'	subject		= TRIM(oDext("Subject"))		: subject	= Replace(Replace(subject, """", "&#34;"), "'","&#39;")
'	content		= TRIM(oDext("msg_body"))		: content	= Replace(Replace(content, """", "&#34;"), "'","&#39;")
'	passwd		= TRIM(oDext("passwd"))
'	email		= TRIM(oDext("email"))
'
'	top_noti	= TRIM(oDext("top_noti"))		: If top_noti	= ""	Then top_noti = "0"
'	isSecret	= TRIM(oDext("isSecret"))		: If isSecret	= ""	Then isSecret = "0"

	bbs_kind	= Trim(Upload.Form("bbs_kind"))
	ip_addr		= Trim(Upload.Form("ip_addr"))
	userid		= Trim(Upload.Form("userid"))
	username	= Trim(Upload.Form("username"))
	view_target	= Trim(Upload.Form("view_target"))	: If view_target	= ""	Then view_target = "0"
	status		= Trim(Upload.Form("status"))			: If status			= ""	Then status		 = "1"
	bbs_cate	= Trim(Upload.Form("bbs_cate"))		: If bbs_cate		= ""	Then bbs_cate	 = "-"
	st_date		= Trim(Upload.Form("st_date"))		: If st_date		= ""	Then st_date	 = Date
	ed_date		= Trim(Upload.Form("ed_date"))		: If ed_date		= ""	Then ed_date	 = "3000-12-31"
	time_limit	= "0"							: If ed_date <> "3000-12-31" Then time_limit = "1"
	foreword	= Trim(Upload.Form("foreword"))
	subject		= Trim(Upload.Form("Subject"))		: subject	= Replace(Replace(subject, """", "&#34;"), "'","&#39;")
	content		= Trim(Upload.Form("msg_body"))		: content	= Replace(Replace(content, """", "&#34;"), "'","&#39;")
	passwd		= Trim(Upload.Form("passwd"))
	email		= Trim(Upload.Form("email"))

	top_noti	= Trim(Upload.Form("top_noti"))		: If top_noti	= ""	Then top_noti = "0"
	isSecret	= Trim(Upload.Form("isSecret"))		: If isSecret	= ""	Then isSecret = "0"

	check_str	= bbs_kind & userid & username & st_date & ed_date & foreword & subject & passwd & email

	If check_injection(check_str) <> "OK" Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('특수문자나 명령어는 입력하실 수 없습니다.');"
		Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
		Response.Write "</script>"
		Response.End
	Else

		sql	= "select BBS_SEQ.NextVal as NSID from dual "
		Set rs = DBConn.Execute(sql)
			NSid	= rs("NSID")
		rs.Close	: Set rs = Nothing

		Grp	= NSid : Seq = 1 : Lev = 0

		DBConn.BeginTrans

		sql =		"Insert Into web_bbs (														"
		sql = sql &	"	sid,		grp,		seq,		Lev,		bbs_kind,	bbs_cate,	"
		sql = sql & "	target,		status,		userid,		username,	isSecret,	passwd,		"
		sql = sql &	"	st_date,	ed_date,	top_noti,	foreword,	subject,	content,	"
		sql = sql &	"	Email,		File1_name, File2_name, File3_name, File4_name,	File5_name,	"
		sql = sql & "	time_limit,	ip_addr)													"
		sql = sql &	"Values(																	"
		sql = sql &	""	& NSid				& ",												"
		sql = sql &	""	& Grp				& ",												"
		sql = sql &	""	& Seq				& ",												"
		sql = sql &	""	& Lev				& ",												"
		sql = sql &	"'"	& bbs_kind			& "',												"
		sql = sql &	"'" & bbs_cate			& "',												"
		sql = sql &	"'" & view_target		& "',												"
		sql = sql &	"'" & status			& "',												"
		sql = sql &	"'"	& userid			& "',												"
		sql = sql &	"'"	& username			& "',												"
		sql = sql &	"'" & isSecret			& "',												"
		sql = sql &	"'"	& passwd			& "',												"
		sql = sql & "'" & st_date			& "',												"
		sql = sql & "'" & ed_date			& "',												"
		sql = sql &	"'" & top_noti			& "',												"
		sql = sql &	"'" & foreword			& "',												"
		sql = sql &	"'"	& subject			& "',												"
		sql = sql &	"'"	& "empty_clob()"	& "',												"
		sql = sql &	"'"	& email				& "',												"

		For j = 1 To nFileCount
			sql =	sql &	"'"	& arrFileName(j)	& "',										"
		Next

		FOR k = nFileCount+1 TO 5
			SQL =	SQL &	"'',																"
		NEXT

		sql = sql &	"'"	& time_limit		& "',												"
		sql = sql & "'" & ip_addr			& "')												"
'Response.write sql
		DBConn.Execute(sql)

		If DBConn.Errors.Count = 0 Then

			DBConn.CommitTrans
			Set rs_update = Server.CreateObject("ADODB.RecordSet")
				rs_update.open "select content from web_bbs where sid = " & NSid, DBConn, 3,3
				rs_update.fields("content").appendChunk(content)
				rs_update.update
				rs_update.Close

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 등록이 완료되었습니다.');"
			If Session("admin") <> "" Then
			Response.Write "	parent.location.href = './bbs_list.asp?bbs_kind=" & bbs_kind & "';"
			Else
			Response.Write "	parent.location.href = './bbs_resp_list.asp?bbs_kind=" & bbs_kind & "';"

			End If

			Response.Write "</script>"

		Else
			Response.write Err.Description
			DBConn.RollBackTrans

			msg = err.description : msg = replace(msg,"'","")
			msg = err.description : msg = replace(msg,"""","")

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 등록에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
			Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
		End If

		Set oDext = Nothing
		Response.End

	End If
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