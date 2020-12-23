<!-- #include virtual ="/myoffice/common/common.inc" -->
<%
	On Error Resume Next

	cate_cd	= Request.Form("cate_cd")

	DBConn.BeginTrans

	sql	=		"delete From web_faq_cate			"
	sql = sql & " where cate_cd in (" & cate_cd &")	"

	DBConn.Execute(sql)

	If DBConn.Errors.Count = 0 Then
		DBConn.CommitTrans
		Response.Write "<script language=javascript>"
		Response.Write "	alert('삭제 되었습니다.');"
		Response.Write "	parent.location.href = './faq_cate_list.asp';"
		Response.Write "</script>"
		Response.End
	Else
		DBConn.RollBackTrans
		Response.Write "<script language=javascript>"
		Response.Write "	alert(' 삭제 과정에 문제가 있습니다.\n\n다시 한 번 시도해 주십시오.');"
		'Response.Write "	history.back();"
		Response.Write "</script>"
		Response.End
	End If


	Set oDext = Nothing


%>



