<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/admin/schedule_common.inc" -->

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" rel="stylesheet" type="text/css">
</head>
<%
set rs = server.createobject("adodb.recordset")
rs.cursortype = 3
sql =		"select *									"
sql = sql & "  from web_schedule						"
sql = sql & " order by years desc, moth desc, days desc	"
rs.open sql, dbconn

if (rs.bof and rs.eof) then
	totrecord = 0
	totpage   = 0
else
	totrecord	= rs.recordcount
	rs.pagesize = pagesize			'한페이지에 보여줄 레코드개수
	totpage		= rs.pagecount
end if
%>

<body onLoad="resize_height();">
<br>
<!--
<table width="<%=tbl_width%>" border="0" align="center" cellpadding="0" cellspacing="3" style="margin-top:0px">
	<tr><td height="10"></td></tr>
	<form name="search" method="post" action="list.asp">
	<input type="hidden" name="board_id" value="<%=board_id%>">
	<tr>
		<td align="right">
			<select name="srch_key"
					class="select"
					style="width:80px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="name" <% If srch_key = "name" Then response.write "selected" %>>작성자</option>
				<option value="subject" <% If srch_key = "subject" Then response.write "selected" %>>제목</option>
				<option value="content" <% If srch_key = "content" Then response.write "selected" %>>내용</option>
	        </select>
			<input NAME="srch_val" type="text" class="textbox01" size="20" style="padding-left:5px;" onKeypress="checkkeycode(event)" value="<%=srch_val%>">
			<input type="image" src="img/btn_search.gif" align="absmiddle">
		</td>
	</tr>
	</form>
	<tr><td height="10"></td></tr>
</table>
-->
<table width="<%=tbl_width%>" border="0" bgcolor="#E7E7E7" cellspacing="0" cellpadding="0" class="title" align="center">
	<tr class="title_bg">
		<td width="5%" height="30" align="center" style="font-size:12px;font-weight:bold;">번호</td>
		<td width="1%" align="center" valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%" align="center" style="font-size:12px;font-weight:bold;">연도</td>
		<td width="1%" align="center" valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%" align="center" style="font-size:12px;font-weight:bold;">월</td>
		<td width="1%" align="center" valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%" align="center" style="font-size:12px;font-weight:bold;">일</td>
		<td width="1%" align="center" valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="" align="center" style="font-size:12px;font-weight:bold;">일정이름</td>
		<td width="1%" align="center" valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="10%" align="center" style="font-size:12px;font-weight:bold;">숨김/보임</td>
		<td width="1%" align="center" valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="10%" align="center" style="font-size:12px;font-weight:bold;">반복</td>
	</tr>
</table>

<% If rs.eof Then %>
<!----------------------------------- Top Notice S ----------------------------------->
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td width="100%" height="150" align="center" valign="middle" >등록된 일정이 없습니다.</td>
	</tr>
</table>
<% Else %>
<!----------------------------------- BBS List   S ----------------------------------->
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" align="center">
<%
	'------------------- 반복일정 우선 표시
	sql =		"select	reg_no, years, moth, days, subject, bgcolor, reg_date,			"
	sql = sql & "		decode(view_web,'0','숨김','1','보임') as view_web				"
	sql = sql & "  from	web_schedule													"
	sql = sql & " where	view_web = '1'													"
	sql = sql & "   and	repeat_yn = '1'													"
	sql = sql & "   and	To_Char(sysdate,'yyyy-mm') between repeat_start and repeat_end	"
	sql = sql & " order by years desc, moth desc, days desc								"
	Set rs_re = DBConn.Execute(sql)

	re_cnt = 1
	Do While Not rs_re.Eof
%>
	<tr height="28" bgcolor="#E4F3FA">
		<td width="5%"	align="center"	valign="middle"><%=re_cnt%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%"	align="center"	valign="middle"><%=rs_re("years")%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%"	align="center"	valign="middle"><%=rs_re("moth")%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%"	align="center"	valign="middle"><%=rs_re("days")%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width=""	align="left"	valign="middle">&nbsp;<a href="./schedule_view.asp?reg_no=<%=rs_re("reg_no")%>&page=1"><%=rs_re("subject")%></a></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="10%"	align="center"	valign="middle"><%=rs_re("view_web")%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="10%"	align="center"	valign="middle"><%="반복"%></td>
	</tr>
	<tr>
		<td height="1" colspan="13" class="line"></td>
	</tr>
<%
		re_cnt = re_cnt + 1
		rs_re.MoveNext
	Loop

	If re_cnt > 1 Then
%>
	<tr><td colspan="13" height="1" bgcolor="#B4B4B4"></td></tr>
<%
	End If

	rs.AbsolutePage = iPage '해당 페이지의 첫번째 레코드로 이동한다
	Rcount = rs.PageSize
	imsiNo = TotRecord-(iPage-1)*(Rcount)		'레코드번호로 사용할 임시번호

	cnt = 1
	Do While (Not rs.eof) And (Rcount > 0 )

		If rs("repeat_yn") = "0" Then

			reg_no		= rs("reg_no")
			sch_yy		= rs("years")
			sch_mm		= rs("moth")
			sch_dd		= rs("days")
			subject		= rs("subject")
			view_web	= "보임"		: If rs("view_web") = "0" Then view_web = "숨김"
			repeat_yn	= ""			: If rs("repeat_yn") = "1" Then repeat_yn = "반복"
%>
	<tr height="28">
		<td width="5%"	align="center"	valign="middle"><%=imsiNo%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%"	align="center"	valign="middle"><%=sch_yy%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%"	align="center"	valign="middle"><%=sch_mm%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="6%"	align="center"	valign="middle"><%=sch_dd%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width=""	align="left"	valign="middle">&nbsp;<a
		href="./schedule_view.asp?reg_no=<%=reg_no%>&page=<%=iPage%>"><%=subject%></a></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="10%"	align="center"	valign="middle"><%=view_web%></td>
		<td width="1%"	align="center"	valign="bottom"><img src="/bbs/img/bar.gif"></td>
		<td width="10%"	align="center"	valign="middle"><%=repeat_yn%></td>
	</tr>
	<tr>
		<td height="1" colspan="13" class="line"></td>
	</tr>
<%
			cnt		= cnt + 1
			imsiNo	= imsiNo-1
			Rcount	= Rcount -1
		End If

		rs.movenext
	loop
end if

rs.Close : Set rs = Nothing
%>
	<tr>
		<td height="1" colspan="13" class="line"></td>
	</tr>
</table>
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td align="right">
			<% If session("admin") <> "" Or board_id = "QNA" Then %>
				<a href="./schedule_write.asp?<%=var1%>"><img src="/bbs/img/btn_write3.gif" border="0"></a>
			<% End If %>
		</td>
	</tr>
</table>
<!----------------------------------- BBS List   E ----------------------------------->

<!----------------------------------- Page Number S ----------------------------------->
<table border="0" align="center" cellpadding="0" cellspacing="0">
	<tr height="50" valign="middle">
		<%
		var2	= ""
		var2	= var2 &		"board_id=" & board_id
		var2	= var2 & "&" &	"srch_Key="	& srch_Key
		var2	= var2 & "&" &	"srch_Val="	& srch_Val
		%>
		<td width="30" align="center"><a href="./schedule_list.asp?<%=var2%>&page=1"><img src="img/ic_prv.gif" align="middle" /border="0"></a></td>
		<td>
		<%
		gsize	= groupsize
		pregnum = (iPage - 1) \ gsize
		endpnum = pregnum * gsize

		If (endpnum > 0) Then
		%>
			<a href="./schedule_list.asp?<%=var2%>&page=<%=endpnum%>">이전</a>
		<%
		End if

		lcount	= gsize
		inti	= endpnum + 1

		Do While (lcount > 0) and (inti <= totpage)

			'현재 페이지의 색상 표현
			if inti = ipage then
				inti2 = "<b><span style='color:#ed5681;font-size:16px;font-weight:bold;'>[" & inti & "]</span></b>"
			else
				inti2 = inti
			end if
		%>
			&nbsp;<a href="./schedule_list.asp?<%=var2%>&page=<%=intI%>"><span style="font-size:13px;"><%=inti2%></span></a>
		<%
			inti = inti + 1
			lcount = lcount - 1
		Loop

		inti = endpnum + (gsize + 1)

		IF (inti <= totpage ) Then
		%>
			<a href="./schedule_list.asp?<%=var2%>&page=<%=intI%>">다음</a>
		<%
		End if
		%>
		</td>
		<td width="30" align="center"><A HREF="./schedule_list.asp?<%=var2%>&page=<%=totpage%>"><img src="img/ic_next.gif" align="middle"/border="0"></a>
		</td>
	</tr>
</table>
<!----------------------------------- Page Number E ----------------------------------->
</body>
</html>
<script language="javascript">
function checkkeycode(t){
  if((t.keyCode > 32 && t.keyCode < 48) || (t.keyCode > 57 && t.keyCode < 65)||(t.keyCode > 90 && t.keyCode < 97))
  {
   t.returnValue = false;
   alert("특수문자나 공백은 입력하실 수 없습니다.");
  }
 }
</script>

<script language=javascript>
function resize_height()
{
	var h_size = document.body.scrollHeight;
	if (h_size < 400) { h_size = 400; }

	if(parent.document.getElementById("bbs_iframe")) {
		parent.document.getElementById("bbs_iframe").height = h_size;
	}
}
</script>