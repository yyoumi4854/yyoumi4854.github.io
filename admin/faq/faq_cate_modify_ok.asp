<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<%
Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001

On Error Resume Next

	work_user	= TRIM(Request.Form("userid"))		: If work_user = "" Then work_user = Session("work_user")
	cate_cd		= TRIM(Request.Form("cate_cd"))
	cate_kind	= TRIM(Request.Form("cate_kind"))
	isuse		= TRIM(Request.Form("isuse"))
	cate_name	= TRIM(Request.Form("cate_name"))	: cate_name	= Replace(Replace(cate_name, """", "&#34;"), "'","&#39;")
	parent_cd	= TRIM(Request.Form("parent_cd"))
	order_view	= TRIM(Request.Form("order_view"))

	check_str	= cate_cd & cate_kind & cate_name & parent_cd & order_view

	If check_injection(check_str) <> "OK" Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('특수문자나 명령어는 입력하실 수 없습니다.');"
		Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
		Response.Write "</script>"
		Response.End
	Else

		sql	= "select cate_cd as NSID from web_faq_cate where cate_cd = '" & cate_cd & "'	"
		Set rs = DBConn.Execute(sql)
		If rs.EOF Then
			Response.Write "<script language=javascript>"
			Response.Write "	alert('카테고리 등록에 실패했습니다.\n\n카테고리 코드가 정확하지 않습니다.');"
			Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
			Response.End
		End If
		rs.Close	: Set rs = Nothing

		DBConn.BeginTrans

		sql =		"update web_faq_cate set						"
		sql = sql &	"	cate_kind		= '" & cate_kind	& "',	"
		sql = sql &	"	cate_name		= '" & cate_name	& "',	"
		sql = sql &	"	isuse			= '" & isuse		& "',	"
		sql = sql &	"	order_view		= '" & order_view	& "',	"
		sql = sql &	"	update_user		= '" & work_user	& "',	"
		sql = sql &	"	update_date		=  " & "sysdate"	& "		"
		sql = sql &	" where cate_cd		= '" & cate_cd 		& "'	"
		DBConn.Execute(sql)

		If DBConn.Errors.Count = 0 Then

			DBConn.CommitTrans
'			Set rs_update = Server.CreateObject("ADODB.RecordSet")
'				rs_update.open "select answer from web_faq where regno = " & NSid, DBConn, 3,3
'				rs_update.fields("answer").appendChunk(answer)
'				rs_update.update
'				rs_update.Close

			Response.Write "<script language=javascript>"
			Response.Write "	alert('카테고리 등록이 완료되었습니다.');"
			Response.Write "	parent.location.href = './faq_cate_list.asp?bbs_kind=" & bbs_kind & "&pdt_cd="&pdt_cd&"';"
			Response.Write "</script>"

		Else
			Response.write Err.Description
			DBConn.RollBackTrans

			msg = err.description : msg = replace(msg,"'","")
			msg = err.description : msg = replace(msg,"""","")

			Response.Write "<script language=javascript>"
			Response.Write "	alert('카테고리 등록에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
			Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
		End If

	End If


%>