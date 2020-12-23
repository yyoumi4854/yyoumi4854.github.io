<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/admin/schedule_common.inc" -->
<%
reg_no	= Request("reg_no")
page	= Request("page")

sql	=		"select *					"
sql = sql & "  from web_schedule		"
sql = sql & " where reg_no = " & reg_no
Set rs = DBConn.Execute(sql)
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" rel="stylesheet" type="text/css">
</head>
<body onLoad="resize_height();">
<% If Session("admin") <> "" Then response.write "<br>" %>
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="border-top:2px solid #ffa4be; border-bottom:2px solid #dddddd" align="center">
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정제목</td>
		<td align="left" class="paddingL10"><%=rs("subject")%></td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정일자</td>
		<td align="left" class="paddingL10">
			<%=rs("years")%>년&nbsp;<%=rs("moth")%>월&nbsp;<%=rs("days")%>일
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">표시여부</td>
		<td align="left" class="paddingL10">
			<%
			If rs("view_web") = "1" Then
				response.write "표시함"
			Else
				response.write "표시안함"
			End If
			%>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정반복</td>
		<td align="left" class="paddingL10">
			<%
			If rs("repeat_yn") = "1" Then
				response.write "매월반복"
			Else
				response.write "반복안함"
			End If
			%>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">반복기간</td>
		<td align="left" class="paddingL10">
			<%
			If rs("repeat_yn") = "1" Then
				repeat_start = rs("repeat_start")
				response.write Left(repeat_start,4) & "년&nbsp;" & Right(repeat_start,2) & "월&nbsp;&nbsp;~&nbsp;&nbsp;"
				repeat_end	 = rs("repeat_end")
				response.write Left(repeat_end,4) & "년&nbsp;" & Right(repeat_end,2) & "월"
			End If
			%>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="33" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">상세일정</td>
		<td align="left" class="paddingL10" style="padding-top:10px;padding-bottom:10px;">
			<textarea name="Content" class="textbox01" id="content" style="width:500px;height:100px;"><%=rs("content")%></textarea>
		</td>
	</tr>
</table>
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px" align="center">
	<tr>
		<td width="70" height="30" align="left"><a href="./schedule_list.asp?page=<%=page%>"><img src="img/btn_list3.gif"></a></td>
		<td align="right" class="paddingL10">
			<a href="./schedule_edit.asp?reg_no=<%=reg_no%>&mode=EDIT&page=<%=page%>"><img src="img/btn_modify3.gif"></a>
			<a href="./schedule_edit.asp?reg_no=<%=reg_no%>&mode=DEL&page=<%=page%>"><img src="img/btn_del3.gif"></a>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<script language=javascript>
function resize_height()
{
	var h_size = document.body.scrollHeight;
	if (h_size < 500) { h_size = 500; }

	if(parent.document.getElementById("bbs_iframe")) {
		parent.document.getElementById("bbs_iframe").height = h_size;
	}
}
</script>