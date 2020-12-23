<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<!-- #include virtual ="/bbs/freeaspupload.html" -->
<%
Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001

On Error Resume Next

'====================파일 업로드 부분 ===========================
  Dim uploadsDirVar
  Dim Upload, fileName, fileSize, ks, i, fileKey,webPath,fileIndex,arrFileName
  webPath = "/bbs/upload"
  uploadsDirVar =  Server.mappath(webPath)
  Set Upload = New FreeASPUpload
  Upload.Save(uploadsDirVar) '파일 업로드

	ks = Upload.UploadedFiles.keys
	if (UBound(ks) <> -1) Then
		If UBound(ks) < 5 Then
			ReDim arrFileName(5)
		Else
			ReDim arrFileName(UBound(ks))
		End If
		fileIndex=0
		for each fileKey in Upload.UploadedFiles.keys
			arrFileName(fileIndex) = webPath &"/"& Upload.UploadedFiles(fileKey).FileName 	'파일명 가져옴
			fileIndex=fileIndex+1
		Next
	Else
		ReDim arrFileName(5)
	end If

'====================파일 업로드 부분 =============================


	work_user	= TRIM(Upload.Form("userid"))	: If work_user = "" Then work_user = Session("work_user")
	faq_kind	= TRIM(Upload.Form("faq_kind"))
	faq_cate	= TRIM(Upload.Form("faq_cate"))
	isuse		= TRIM(Upload.Form("isuse"))
	subject		= TRIM(Upload.Form("subject"))	: subject	= Replace(Replace(subject, """", "&#34;"), "'","&#39;")
	answer		= TRIM(Upload.Form("msg_body"))	: answer	= Replace(Replace(answer, """", "&#34;"), "'","&#39;")
	pdt_cate	= TRIM(Upload.Form("pdt_cate"))

	check_str	= faq_kind & faq_cate & subject & answer

	If check_injection(check_str) <> "OK" Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('특수문자나 명령어는 입력하실 수 없습니다.');"
		Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
		Response.Write "</script>"
		Response.End
	Else

		sql	= "select POPUP_SEQ.NextVal as NSID from dual "
		Set rs = DBConn.Execute(sql)
			NSid	= rs("NSID")
		rs.Close	: Set rs = Nothing

		Grp	= NSid : Seq = 1 : Lev = 0

		DBConn.BeginTrans

		sql =		"Insert Into web_faq (										"
		sql = sql &	"	reg_no,		faq_kind,	faq_cate,	isuse,				"
		sql = sql & "	subject,	answer,		file_name,	pdt_cate,			"
		sql = sql &	"	work_user	)											"
		sql = sql &	"Values (													"
		sql = sql &	""	& NSid					& ",							"
		sql = sql &	"'"	& faq_kind				& "',							"
		sql = sql &	"'"	& faq_cate				& "',							"
		sql = sql &	"'"	& isuse					& "',							"
		sql = sql &	"'"	& subject				& "',							"
		sql = sql &	"'" & answer				& "',							"
		sql = sql &	"'" & file_name				& "',							"
		sql = sql &	"'" & pdt_cate				& "',							"
		sql = sql &	"'"	& work_user				& "')							"
		DBConn.Execute(sql)

		If DBConn.Errors.Count = 0 Then

			DBConn.CommitTrans
'			Set rs_update = Server.CreateObject("ADODB.RecordSet")
'				rs_update.open "select answer from web_faq where regno = " & NSid, DBConn, 3,3
'				rs_update.fields("answer").appendChunk(answer)
'				rs_update.update
'				rs_update.Close

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 등록이 완료되었습니다.');"
			Response.Write "	parent.location.href = './faq_list.asp?bbs_kind=" & bbs_kind & "&pdt_cd="&pdt_cd&"';"
			Response.Write "</script>"

		Else
			Response.write Err.Description
			DBConn.RollBackTrans

			msg = err.description : msg = replace(msg,"'","")
			msg = err.description : msg = replace(msg,"""","")

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 등록에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
			'Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
		End If

	End If


%>