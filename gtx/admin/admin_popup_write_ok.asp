<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/function.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<%
Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001

'On Error Resume Next

Set oDext = Server.CreateObject("DEXT.FileUpload")
oDext.DefaultPath	= Server.MapPath("\bbs\upload")
Response.WRite Server.MapPath("\bbs\upload")
oDext.MaxFileLen	= maxSize


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

		sql	= "select POPUP_SEQ.NextVal as NSID from dual "
		Set rs = DBConn.Execute(sql)
			NSid	= rs("NSID")
		rs.Close	: Set rs = Nothing

		Grp	= NSid : Seq = 1 : Lev = 0

		DBConn.BeginTrans

		sql =		"Insert Into web_popup_L (													"
		sql = sql &	"	regno,		title,		p_top		,		p_left	,	width,			"
		sql = sql & "	height,		zindex,		isdrag	,	isusedate	,	st_date,			"
		sql = sql &	"	ed_date,	work_user,	work_name,	popup_status,	content )			"
		sql = sql &	"Values(																	"
		sql = sql &	""	& NSid				& ",												"
		sql = sql &	"'"	& subject			& "',												"
		sql = sql &	"'"	& pop_top				& "',											"
		sql = sql &	"'"	& pop_left				& "',											"
		sql = sql &	"'"	& pop_width			& "',												"
		sql = sql &	"'" & pop_height			& "',											"
		sql = sql &	"'" & pop_zindex			& "',											"
		sql = sql &	"'"	& popup_drag			& "',											"
		sql = sql &	"'" & pop_usedate		& "',												"
		sql = sql & "'" & st_date			& "',												"
		sql = sql & "'" & ed_date			& "',												"
		sql = sql &	"'"	& userid			& "',												"
		sql = sql &	"'"	& username			& "',												"
		sql = sql &	"'" & popup_status			& "',											"
		sql = sql &	"'"	& "empty_clob()"	& "')												"


Response.WRite sql
		DBConn.Execute(sql)

		If DBConn.Errors.Count = 0 Then

			DBConn.CommitTrans
			Set rs_update = Server.CreateObject("ADODB.RecordSet")
				rs_update.open "select content from web_popup_L where regno = " & NSid, DBConn, 3,3
				rs_update.fields("content").appendChunk(content)
				rs_update.update
				rs_update.Close

			Response.Write "<script language=javascript>"
			Response.Write "	alert('게시물 등록이 완료되었습니다.');"
			Response.Write "	parent.location.href = './admin_popup.asp?bbs_kind=" & bbs_kind & "&pdt_cd="&pdt_cd&"';"
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

		Set oDext = Nothing
		Response.End

	End If


%>