<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<!-- #include virtual ="/bbs/freeaspupload.html" -->
<%
Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001

'On Error Resume Next

'====================파일 업로드 부분 ===========================
  Dim uploadsDirVar
  Dim Upload, fileName, fileSize, ks, i, fileKey,webPath,fileIndex,arrFileName
  webPath = "/bbs/upload"
  uploadsDirVar =  Server.mappath(webPath)
  Set Upload = New FreeASPUpload
  Upload.Save(uploadsDirVar) '파일 업로드

	ks = Upload.UploadedFiles.keys
	If (UBound(ks) <> -1) Then
		If UBound(ks) < 5 Then
			ReDim arrFileName(5)
		Else
			ReDim arrFileName(UBound(ks))
		End If
		fileIndex=0
		For Each fileKey In Upload.UploadedFiles.keys
			arrFileName(fileIndex) = webPath &"/"& Upload.UploadedFiles(fileKey).FileName 	'파일명 가져옴
			fileIndex=fileIndex+1
		Next
	Else
		ReDim arrFileName(5)
	End If
	file_name = arrFileName(0)
'====================파일 업로드 부분 =============================


	work_user	= TRIM(Upload.Form("userid"))	: If work_user = "" Then work_user = Session("work_user")
	reg_no		= TRIM(Upload.Form("reg_no"))
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

		DBConn.BeginTrans

		sql =		"update web_faq set								"
		sql = sql &	"		faq_kind	= '" & faq_kind		& "',	"
		sql = sql &	"		faq_cate	= '" & faq_cate		& "',	"
		sql = sql &	"		isuse		= '" & isuse		& "',	"
		sql = sql &	"		subject		= '" & subject		& "',	"
		sql = sql &	"		answer		= '" & answer		& "',	"
		sql = sql &	"		pdt_cate	= '" & pdt_cate		& "',	"
		If file_name <> "" Then
		sql = sql &	"		file_name	= '" & file_name	& "',	"
		End If
		sql = sql &	"		update_user	= '" & work_user	& "',	"
		sql = sql &	"		update_date	= "	 & "sysdate"	& "		"
		sql = sql & " where reg_no = "	 & reg_no
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
			Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
		End If

	End If


%>