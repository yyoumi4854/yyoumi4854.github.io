<%@ CodePage="65001" Language="vbscript"%>
<!-- #include virtual ="/myoffice/common/common.inc" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/board/css/style.css" rel="stylesheet" type="text/css">
</head>
<script language="javascript">
function frm_chk() {
	if (document.form.filename1.value == "") {
		alert("등록하실 사진을 선택해 주십시오.");
		document.form.filename1.focus();
		return false;
	} else {
		document.form.submit();
	}
}
</script>

<%
On Error Resume Next

userid	  = Trim(Request("userid"))
rank_cd	  = Trim(Request("rank_cd"))
pay_month = Trim(Request("pay_month"))
page_str  = Trim(Request("p_str"))
mode	  = Trim(Request("mode"))

If mode = "DEL" Then

	DBConn.BeginTrans

	sql =		"delete from web_rankup							"
	sql = sql & " where	userid		= '" & userid		& "'	"
	sql = sql & "   and	rank_month	= '" & pay_month	& "'	"
	sql = sql & "   and	rank_cd		=  " & rank_cd
	DBConn.Execute(sql)

	If DBConn.Errors.Count = 0 Then
		DBConn.CommitTrans
		page_str = Replace(page_str,"$","&")
		url = "opener.location.href = './rankup_list.asp?" & page_str & "';"

		Response.Write "<script language=javascript>"
		Response.Write "	alert('사진이 삭제되었습니다.');"
		Response.Write url
		Response.Write "	window.close();"
		Response.Write "</script>"
	Else
		DBConn.RollBackTrans
		msg = err.description : msg = replace(msg,"'","")

		Response.Write "<script language=javascript>"
		Response.Write "	alert('사진 등록에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
		Response.Write "	window.close();"
		Response.Write "</script>"
	End If

Else

	sql =		"select	a.userid, a.username, a.pay_month,	"
	sql = sql & "		a.rank_cd, b.rank_name				"
	sql = sql & "  from	pay_month a, rank b					"
	sql = sql & " where	a.rank_cd = b.rank_cd				"
	sql = sql & "   and	a.pay_month = '" & pay_month & "'	"
	sql = sql & "   and	a.userid = '" & userid & "'			"
	sql = sql & "   and	a.rank_cd = " & rank_cd
	Set rs = DBConn.Execute(sql)
%>
	<body>
	<form method="post" action="rank_photo_reg_ok.asp" name="form" onSubmit="return frm_chk();" enctype="multipart/form-data">
	<input type="hidden" name="mode"		value="<%=mode%>">
	<input type="hidden" name="userid"		value="<%=userid%>">
	<input type="hidden" name="username"	value="<%=rs("username")%>">
	<input type="hidden" name="rank_cd"		value="<%=rank_cd%>">
	<input type="hidden" name="rank_name"	value="<%=rs("rank_name")%>">
	<input type="hidden" name="rank_month"	value="<%=pay_month%>">
	<input type="hidden" name="page_str"	value="<%=page_str%>">
	<input type="hidden" name="work_user"	value="<%=Session("Login_ID")%>">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-top:2px solid #ffa4be;" align="center">
		<tr class="title_bg">
			<td colspan="2" height="40" align="center" style="font-size:13px;font-weight:bold;color:#000000;">승급자 사진 등록</td>
		</tr>
		<tr><td height="10" colspan="2"></td></tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr height="30">
			<td width="20%" align="center" valign="middle" bgcolor="#E7EEEF">회원번호</td>
			<td width="80%" align="left" valign="middle" style="padding-left:10px;"><%=userid%></td>
		</tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr height="30">
			<td width="20%" align="center" valign="middle" bgcolor="#E7EEEF">회원성명</td>
			<td width="80%" align="left" valign="middle" style="padding-left:10px;"><%=rs("username")%></td>
		</tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr height="30">
			<td width="20%" align="center" valign="middle" bgcolor="#E7EEEF">승급연월</td>
			<td width="80%" align="left" valign="middle" style="padding-left:10px;"><%=rs("pay_month")%></td>
		</tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr height="30">
			<td width="20%" align="center" valign="middle" bgcolor="#E7EEEF">승급직급</td>
			<td width="80%" align="left" valign="middle" style="padding-left:10px;"><%=rs("rank_name")%></td>
		</tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr height="40">
			<td width="20%" align="center" valign="middle" bgcolor="#E7EEEF">사진등록</td>
			<td width="80%" align="left" valign="middle" style="padding-left:10px;">
				<input type="file" name="filename1" class="textbox01" size="24">
			</td>
		</tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr height="80">
			<td colspan="2" align="center" valign="middle">
				<img src="/img/btn_save.gif" style="cursor:pointer;" onClick="frm_chk();">
			</td>
		</tr>
	</table>
<% End If %>
</body>
</html>