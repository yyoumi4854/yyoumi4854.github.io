<!-- #include virtual="/myoffice/common/db_connect.inc" -->
<%
board_id	= "NOTICE"
table_width	= "353"
table_height= "104"
td_height	= "20"
article_cnt	= "5"
%>
<table width="<%=table_width%>" height="<%=table_height%>" border="0" cellspacing="0" cellpadding="0">
<%
sql =		"select	/*+ INDEX_DESC(web_board WEB_BOARD_IDX1)*/	"
sql	= sql &	"		sid, subject, work_date						"
sql = sql & "  from web_board									"
sql = sql & " where	board_id = '" & board_id & "'				"
sql = sql & "   and	rownum <= " & article_cnt
Set rs = DBconn.execute(Sql)

If Not rs.eof Then
	Do While Not rs.eof
		subject	= rs("subject")
		If Len(subject) > 13 Then subject = Left(subject,12) + ".."
%>
		<tr height="<%=td_height%>">
			<td width="15" align="center" valign="middle"><img src="img/dot_gray.gif"/></td>
			<td align="left" class="news"><a href="/community/community_01.asp?action=VIEW&sid=<%=rs("sid")%>"><%=subject%></a></td>
			<td width="80" align="right" class="news"><%=Left(rs("work_date"),10)%></td>
		</tr>
<%
		rs.movenext
	Loop
Else
%>
		<tr height="<%=td_height%>">
			<td width="100%" align="center" valign="middle">등록된 게시물이 없습니다.</td>
		</tr>
<%
End	If

rs.close
%>
</table>