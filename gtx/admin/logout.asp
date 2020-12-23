<%@ CodePage="65001" Language="vbscript"%>
<%
Response.charset = "utf-8"
Session.CodePage=65001

Session.Abandon
SESSION("ADMIN")	= ""
SESSION("MEMB_NAME")= ""
SESSION("LOGIN_ID") = ""
SESSION("ADMIN_LV") = ""

Response.Write "<script language='javascript'>"
Response.Write "	alert('이용해 주셔서 감사합니다.');"
Response.Write "	top.location.href= '/';"
Response.Write "</script>"

%>