<!-- #include virtual ="/myoffice/common/common.inc" -->

<!-- #include virtual ="/myoffice/common/function.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<%
Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001
On Error Resume Next

Set oDext = Server.CreateObject("DEXT.FileUpload")
oDext.DefaultPath	= Server.MapPath("\bbs\upload")
oDext.MaxFileLen	= maxSize

	sid			= TRIM(oDext("sid"))
	userid		= TRIM(oDext("userid"))
	username	= TRIM(oDext("username"))
	pop_left	= TRIM(oDext("pop_left"))
	pop_top		= TRIM(oDext("pop_top"))
	pop_width	= TRIM(oDext("pop_width"))
	pop_height	= TRIM(oDext("pop_height"))
	pop_zindex	= TRIM(oDext("pop_zindex"))
	popup_drag	= TRIM(oDext("popup_drag"))
	pop_usedate = TRIM(oDext("pop_usedate"))

	popup_status= TRIM(oDext("popup_status"))	: If popup_status			= ""	Then popup_status		 = "1"
	st_date		= TRIM(oDext("st_date"))		: If st_date		= ""	Then st_date	 = Date
	ed_date		= TRIM(oDext("ed_date"))		: If ed_date		= ""	Then ed_date	 = "3000-12-31"
	subject		= TRIM(oDext("Subject"))		: subject	= Replace(Replace(subject, """", "&#34;"), "'","&#39;")
	content		= TRIM(oDext("msg_body"))		: content	= Replace(Replace(content, """", "&#34;"), "'","&#39;")

	check_str	= bbs_kind & userid & username & st_date & ed_date & foreword & subject & content & passwd & email

	If check_injection(check_str) <> "OK" Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('특수문자나 명령어는 입력하실 수 없습니다.');"
		Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
		Response.Write "</script>"
		Response.End
	Else

		DBConn.BeginTrans

		sql =		"update web_popup_L									"
		sql = sql & "   set	TITLE				= '" & subject	& "',	"
		sql = sql & "		POPUP_STATUS		= '" & popup_status		& "',	"
		sql = sql & "		P_TOP				= '" & pop_top		& "',	"
		sql = sql & "		P_LEFT				= '" & pop_left		& "',	"
		sql = sql & "		WIDTH				= '" & pop_width		& "',	"
		sql = sql & "		HEIGHT				= '" & pop_height		& "',	"
		sql = sql & "		ZINDEX				= '" & pop_zindex		& "',	"
		sql = sql & "		ISDRAG				= '" & popup_drag	& "',	"
		sql = sql & "		ISUSEDATE			= '" & pop_usedate		& "',	"
		sql = sql & "		ST_DATE				= '" & st_date		& "',	"
		sql = sql & "		ED_DATE				= '" & ed_date		& "',	"
		sql = sql & "		content				= '" & content		& "',	"
		sql = sql & "		update_user			= '" & userid		& "',	"
		sql = sql & "		update_name			= '" & update_name	& "',	"
		sql = sql & "		update_date			= sysdate					"
		sql = sql & " where	regno						=  " & sid
Response.WRite sql
'Response.End
		DBConn.Execute(sql)

		If DBConn.Errors.Count = 0 Then
			DBConn.CommitTrans

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 수정이 완료되었습니다.');"
			Response.Write "	parent.location.href = './admin_popup.asp?" & link_query & "&sid=" & sid & "';"
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

	Set oDext = Nothing


%>


