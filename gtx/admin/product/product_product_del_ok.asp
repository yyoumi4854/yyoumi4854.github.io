<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual="/bbs/freeaspupload.html" -->

<%
	On Error Resume Next

	webPath = "\bbs\upload"
	uploadsDirVar =  Server.mappath(webPath)
	Set Upload = New FreeASPUpload
	Upload.Save(uploadsDirVar) 'Upload.Save("")를 선언해야 Upload.Form을 사용하여 파라미터를 받을 수 있음

	sid			= Upload.Form("sid")

	DBConn.BeginTrans

	sql	=		"delete From PDT_WEBINFO				"
	sql = sql & " where WEBINFO_CD in (" & sid &")			"

	DBConn.Execute(sql)








	If DBConn.Errors.Count = 0 Then
		DBConn.CommitTrans
		Response.Write "<script language=javascript>"
		Response.Write "	alert('삭제 되었습니다.');"
		Response.Write "	parent.location.href = './product_product.asp';"
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



