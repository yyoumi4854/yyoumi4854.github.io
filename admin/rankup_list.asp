<%@ CodePage="65001" Language="vbscript"%>
<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual="/board/bbs_common.inc" -->

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/board/css/style.css" rel="stylesheet" type="text/css">
</head>
<%
rank_yy		= Request("rank_yy")	: If (rank_yy = "--") Or (rank_yy = "") Then rank_yy = Year(Date)
rank_mm		= Request("rank_mm")	: If (rank_mm = "--") Or (rank_mm = "") Then rank_mm = Right("0"&Month(Date),2)
show_month	= rank_yy & "-" & Right("0"&rank_mm,2)
rank_cd		= Request("rank_cd")
username	= Request("username")

val1 = "rank_yy=" & rank_yy & "&rank_mm=" & rank_mm & "&rank_cd=" & rank_cd & "&username=" & username
val2 = Replace(val1,"&","$")

Set rs = Server.CreateObject("ADODB.RecordSet")
rs.CursorType = 3

sql =		"select	a.pay_month, a.userid, a.username, a.rank_cd,			"
sql = sql & "		c.rank_name as old_rank, d.rank_name as new_rank,		"
sql = sql & "       Nvl(e.photo,'-') as photo								"
sql = sql & "  from	pay_month a, pay_info b, rank c, rank d, web_rankup e	"
sql = sql & " where	a.pay_month = b.pay_date								"
sql = sql & "   and	a.pay_month = '" & show_month & "'						"
sql = sql & "   and	a.old_rank_cd = c.rank_cd								"
sql = sql & "   and	a.rank_cd = d.rank_cd									"
sql = sql & "   and	a.userid = e.userid(+)									"
sql = sql & "   and	a.pay_month = e.rank_month(+)							"
sql = sql & "   and	a.rank_cd = e.rank_cd(+)								"
sql = sql & "   and	a.rank_cd >= 3											"	'------ 골드 이상

If (rank_cd <> "--") And (rank_cd <> "") Then
	sql = sql & "   and	a.rank_cd	= " & rank_cd
End If

If username <> "" Then
	sql = sql & "   and	a.username like'%" & username & "%'			"
End If

sql = sql & " order by a.rank_cd, a.username								"

rs.Open sql, DBConn

PageSize = 5

If (rs.bof and rs.eof) Then
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
<table width="<%=tbl_width%>" border="0" align="center" cellpadding="0" cellspacing="3" style="margin-top:0px" class="title">
	<tr><td height="10"></td></tr>
	<form name="search" method="post" action="./rankup_list.asp">
	<tr>
		<td align="right">
			<input type="text" value="승급연월 :" style="width:65px;height:20px;padding-top:3px;border:0px solid #cacaca;font-size:13px;color:#000000;" readOnly onFocus="this.blur()">
			<select name="rank_yy"
					class="select"
					style="width:60px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="--">-연도-</option>
			<% For i=CInt(Year(date))-1 To CInt(rank_yy)+1 %>
				<option value="<%=i%>" <% If i=CInt(rank_yy) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="년" style="width:20px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			<select name="rank_mm"
					class="select"
					style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="--">-월-</option>
			<% For i=1 To 12 %>
				<option value="<%=i%>" <% If i=CInt(rank_mm) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="월" style="width:20px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			&nbsp;&nbsp;/&nbsp;&nbsp;
			<input type="text" value="승급직급 :" style="width:65px;height:20px;padding-top:3px;border:0px solid #cacaca;font-size:13px;color:#000000;" readOnly onFocus="this.blur()">
			<select name="rank_cd"
					class="select"
					style="width:100px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="--" selected>-직급선택-</option>
			<%
			sql = "select rank_cd, rank_name from rank order by rank_cd"
			Set rs_rank = DBConn.Execute(sql)

			Do While Not rs_rank.Eof
			%>
				<option value="<%=rs_rank("rank_cd")%>"><%=rs_rank("rank_name")%></option>
			<%
				rs_rank.MoveNext
			Loop
			%>
			</select>
			&nbsp;&nbsp;/&nbsp;&nbsp;
			<input type="text" value="회원성명 :" style="width:65px;height:20px;padding-top:3px;border:0px solid #cacaca;font-size:13px;color:#000000;" readOnly onFocus="this.blur()">
			<input type="text" NAME="username" size="10" class="textbox01">
			&nbsp;&nbsp;&nbsp;
			<input type="image" src="/board/img/btn_search.gif" align="absmiddle">
		</td>
	</tr>
	</form>
	<tr><td height="10"></td></tr>
</table>
<br>
<!--
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td width="100%" height="30" valign="middle" align="right" style="color:#FF0066;">※ 수당 마감 후 반드시 "수당조회"를 체크하셔야만 해당 리스트가 조회됩니다.</td></tr>
</table>
-->
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" class="title" align="center">
	<tr>
		<td width="5%" height="30" align="center" style="font-size:12px;font-weight:bold;">번호</td>
		<td width="15%" align="center" style="font-size:12px;font-weight:bold;">승급연월</td>
		<td width="15%" align="center" style="font-size:12px;font-weight:bold;">승급직급</td>
		<td width="15%" align="center" style="font-size:12px;font-weight:bold;">회원번호</td>
		<td width="15%" align="center" style="font-size:12px;font-weight:bold;">회원이름</td>
		<td width="" align="center" style="font-size:12px;font-weight:bold;">회원사진</td>
	</tr>
</table>

<% If rs.eof Then %>
<!----------------------------------- Top Notice S ----------------------------------->
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td width="100%" height="150" align="center" valign="middle" >해당 조건에 대한 승급대상자가 없습니다.</td>
	</tr>
</table>
<% Else %>
<!----------------------------------- BBS List   S ----------------------------------->
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" align="center">
<%
	rs.AbsolutePage = iPage '해당 페이지의 첫번째 레코드로 이동한다
	Rcount = rs.PageSize
	imsiNo = TotRecord-(iPage-1)*(Rcount)		'레코드번호로 사용할 임시번호

	cnt = 1
	Do While (Not rs.eof) And (Rcount > 0 )

		q_str = val2 & "$page=" & iPage

		If rs("photo") <> "-" Then
			photo_url =				"<table width=100% border=0 cellpadding=0 cellspacing=0><tr><td width=100 align=right>"
			photo_url = photo_url & "<img src=""/board/upload/rank_photo/" & rs("photo") & """ width=""80"" height=""80"" align=""absmiddle"">"
			photo_url = photo_url & "</td><td align=left style='padding-left:10px;'>"
			photo_url = photo_url & "<input type=""button"" value=""사진삭제"" onClick=""javascript:photo_reg('DEL','" & rs("userid") & "','" & rs("pay_month") & "','" & rs("rank_cd") & "','" & q_str & "');"">"
			photo_url = photo_url & "<br><br>"
			photo_url = photo_url & "<input type=""button"" value=""사진교체"" onClick=""javascript:photo_reg('MOD','" & rs("userid") & "','" & rs("pay_month") & "','" & rs("rank_cd") & "','" & q_str & "');"">"
			photo_url = photo_url & "</td></tr></table>"
		Else
			q_link	  = "?userid=" & rs("userid") & "&pay_month=" & rs("pay_month") & "&rank_cd=" & rs("rank_cd")
			photo_url =				"<table width=100% border=0 cellpadding=0 cellspacing=0><tr><td align=center>"
			photo_url = photo_url & "<input type=""button"" value=""사진등록"" "
			photo_url = photo_url & "onClick=""javascript:photo_reg('NEW','" & rs("userid") & "','" & rs("pay_month") & "','" & rs("rank_cd") & "','" & q_str & "');"">"
			photo_url = photo_url & "</td></tr></table>"
		End If
%>
	<tr height="80">
		<td width="5%"	align="center"	valign="middle" style="padding-top:5px;padding-bottom:5px;"><%=imsiNo%></td>
		<td width="15%"	align="center"	valign="middle" style="padding-top:5px;padding-bottom:5px;"><%=show_month%></td>
		<td width="15%"	align="center"	valign="middle" style="padding-top:5px;padding-bottom:5px;"><%=rs("new_rank")%></td>
		<td width="15%"	align="center"	valign="middle" style="padding-top:5px;padding-bottom:5px;"><%=rs("userid")%></td>
		<td width="15%"	align="center"	valign="middle" style="padding-top:5px;padding-bottom:5px;"><a href="./rankup_list.asp?<%=val1%>&page=<%=iPage%>"><b><%=rs("username")%></b></a></td>
		<td width=""	align="left"	valign="middle" style="padding-top:5px;padding-bottom:5px;padding-left:20px;">
			<%=photo_url%>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="6" class="line"></td>
	</tr>
<%
		cnt		= cnt + 1
		imsiNo	= imsiNo-1
		Rcount	= Rcount -1
		rs.movenext
	loop
end if

rs.Close : Set rs = Nothing
%>
	<tr>
		<td height="1" colspan="6" class="line"></td>
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
		<td width="30" align="center"><a href="./rankup_list.asp?<%=val1%>&page=1"><img src="/board/img/ic_prv.gif" align="middle" /></a></td>
		<td>
		<%
		gsize	= groupsize
		pregnum = (iPage - 1) \ gsize
		endpnum = pregnum * gsize

		If (endpnum > 0) Then
		%>
			<a href="./rankup_list.asp?<%=val1%>&page=<%=endpnum%>">이전</a>
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
			&nbsp;<a href="./rankup_list.asp?<%=val1%>&page=<%=intI%>"><span style="font-size:13px;"><%=inti2%></span></a>
		<%
			inti = inti + 1
			lcount = lcount - 1
		Loop

		inti = endpnum + (gsize + 1)

		IF (inti <= totpage ) Then
		%>
			<a href="./rankup_list.asp?<%=val1%>&page=<%=intI%>">다음</a>
		<%
		End if
		%>
		</td>
		<td width="30" align="center"><A HREF="./rankup_list.asp?<%=val1%>&page=<%=totpage%>"><img src="/board/img/ic_next.gif" align="middle" /></a>
		</td>
	</tr>
</table>
<!----------------------------------- Page Number E ----------------------------------->
</body>
</html>
<script language="javascript">
function photo_reg(mode,u_id,p_month,r_cd,page_str) {

	var url = "./rank_photo_reg.asp?mode=" + mode + "&userid=" + u_id + "&pay_month=" + p_month + "&rank_cd=" + r_cd + "&p_str=" + page_str;
	window.open(url,"PHOTO","left=20,top=30,width=400,height=300,toolbar=no,menubar=no,location=no,scrollbars=yes,statusbar=no");
}

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