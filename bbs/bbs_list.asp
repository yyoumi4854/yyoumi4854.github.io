<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual="/myoffice/common/bbs_common.inc" -->

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="./css/bbs.css" rel="stylesheet" type="text/css">
</head>
<body onLoad="resize_height();" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">

<table id="tbl_search">
	<colgroup>
<%	If bbs_Type ="G" Then
%>
		<col width="800" />	<!-- 글번호 -->
<%
Else
%>
		<col width="930" />	<!-- 글번호 -->
		<%End If%>
	</colgroup>

	<tr>
		<td height="10"></td>
	</tr>
	<form name="search" method="post" action="./bbs_list.asp">
	<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">

	<tr>
		<td class="search_td" style="width:100%;padding:0px;">
			<%
			sql =		"select DISTINCT bbs_cate				"
			sql = sql & "  from	web_bbs							"
			sql = sql & " where	bbs_kind = '" & bbs_kind & "'	"
			sql = sql & " order by bbs_cate						"
			Set rs = DBConn.Execute(sql)

			If Not rs.EOF Then
				srch_cate = Request("srch_cate")
				If srch_cate <> "" Then srch_sql = srch_sql & " and bbs_cate = '" & srch_cate & "'	"
			%>
			<b style="vertical-align:middle;">분류:</b>
			<select name="srch_cate" style="height:20px;vertical-align:middle;margin-right:10px;">
				<option value="">전체</option>
				<%
				Do While Not rs.EOF
					If srch_cate = rs("bbs_cate") Then
						strSelected = " selected"
					Else
						strSelected = ""
					End If
					Response.Write "<option value=""" & rs("bbs_cate") & """" & strSelected & ">" & rs("bbs_cate") & "</option>"
					rs.MoveNext
				Loop
				%>
			</select>
			<%
			End If
			%>
			<select name="srch_key" style="height:20px;vertical-align:middle;">
				<option value="name"	<% If srch_key = "name"		Then Response.Write "selected" %>>작성자</option>
				<option value="subject" <% If srch_key = "subject"	Then Response.Write "selected" %>>제목</option>
				<option value="content" <% If srch_key = "content"	Then Response.Write "selected" %>>내용</option>
	        </select>

			<input NAME="srch_val" type="text" size="20" value="<%=srch_val%>" style="vertical-align:middle;">
			<img src="./img/btn_search.gif" style="cursor:pointer;border:0px;vertical-align:middle;" onClick="document.forms[0].submit();">
		</td>
	</tr>

	</form>
	<tr>
		<td height="10"></td>
	</tr>
</table>

	<%
	'bbs_type=G(겔러리 타입 일때 폼을 바꿈니다.)
	If bbs_type = "G" Then

	Else
	%>
	<table id="tbl_list">
	<colgroup>
		<col width="100" />	<!-- 글번호 -->
		<col width="100" />	<!-- 분류 -->
		<col width="430" />	<!-- 글제목 -->
		<%
		colspanCnt = "5"
		If bbs_type="P" Then
			colspanCnt = "6"
		%>
		<col width="150" />
		<%End If %>
		<col width="150" />	<!-- 작성자 -->
		<col width="150" />	<!-- 등록일 -->
	</colgroup>
	<tr class="header_tr">
		<td class="header_no"		>번호</td>
		<td class="header_no"		>분류</td>
		<td class="header_subject"	>글제목</td>
		<%If bbs_type="P" Then%>
		<td class="header_writer"	>답변여부</td>
		<%End If %>
		<td class="header_writer"	>작성자</td>
		<td class="header_date"		>등록일</td>
	</tr>

	<%
	End If

	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.cursortype = 3
	sql =		"select /*+ INDEX_DESC(web_bbs web_bbs_idx1)*/				"
	sql = sql & "		sid, grp, seq, lev, foreword, subject, username,	"
	sql = sql & "		To_Char(work_date,'yyyy-mm-dd') as work_date,		"
	sql = sql & "		isSecret, ip_addr, visit,file1_name	,answer_status,	"
	sql = sql & "		bbs_cate											"
	sql = sql & "  from web_bbs												"
	sql = sql & " where	bbs_kind = '" & bbs_kind & "'						"
	sql = sql & srch_sql
	sql = sql & " order by grp desc, seq									"
	rs.Open sql, DBConn

	If (rs.Bof and rs.Eof) Then
		TotRecord = 0
		TotPage   = 0
	Else
		TotRecord	= rs.RecordCount
		rs.PageSize = PageSize			'한페이지에 보여줄 레코드개수
		TotPage		= rs.PageCount
	End If

	If rs.eof Then
		If bbs_Type = "G" Then
			%>
				<ul class="no_reg_image">
									<li>등록된 이미지가 없습니다.</li>
			<%
		Else
			%>

			<tr>
				<td colspan="<%=colspanCnt%>" class="no_list">등록된 게시물이 없습니다.</td>
			</tr>

			<%
		End If

	Else
		'----------------------------------------------------------------------- Top Notice S
		If bbs_Type = "G" Then
			%>
				<ul class="gallery_list">
			<%
		End If

		Set rs_n = server.createobject("adodb.recordset")
		rs_n.cursortype = 3
			sql =		"select /*+ INDEX_DESC(web_bbs web_bbs_idx1)*/						"
			sql = sql & "		sid, grp, seq, lev, foreword, subject, username,			"
			sql = sql & "		To_Char(work_date,'yyyy-mm-dd') as work_date,answer_status,	"
			sql = sql & "		bbs_cate													"
			sql = sql & "  from	web_bbs														"
			sql = sql & " where bbs_kind = '" & bbs_kind & "'								"
			sql = sql & "   and top_noti ='1'												"
			sql = sql & " order by sid desc													"
		rs_n.open sql, dbconn

		Do While Not rs_n.Eof

			sid			= rs_n("sid")
			grp			= rs_n("grp")
			seq			= rs_n("seq")
			lev			= rs_n("lev")
			foreword	= rs_n("foreword")
			subject		= rs_n("subject")
				subject = cut_string(subject,50)
				If Not (IsNull(foreword)) Then subject = "[" & foreword & "]" & subject
			username	= rs_n("username")
			work_date	= rs_n("work_date")
			answer_status	= rs_n("answer_status")
			bbs_cate	= rs_n("bbs_cate")


			'겔러리 일때 분류
			If bbs_Type ="G" Then
			%>
				<li>
					<dl>
						<dt><a href="#"><img src="../img/community/set_img.jpg" /></a></dt>
						<dd><a href="#">하반기 신제품 이미지입니다.</a></dd>
						<dd><span class="g_name">홍길동</span><span class="g_date">2014.12.04</span></dd>
					</dl>
				</li>
			<%
			Else
				new_badge = ""
				if datediff("d",work_date,Date()) < 1 then	new_badge = "<img src='./img/icon_new_1.gif' align='absmiddle'>"

				subject		= "<span style=""cursor:pointer;"" onClick=""view_article('" & sid & "','" & isSecret & "');"">" & subject & new_badge & "</span>"
		%>
				<tr class="notice_tr" onMouseOver="this.className='notice_tr_over';" onMouseOut="this.className='notice_tr';">
					<td class="notice_no"		><img src="./img/btn_notice3.gif">	</td>
					<td class="notice_no"		><%=bbs_cate%>	</td>
					<td class="notice_subject"	><%=subject%>	</td>
					<td class="notice_writer"	><%=username%>	</td>
					<%If bbs_type="P" Then%>
					<td class="list_writer"		><%If answer_status="0" Then Response.Write "미답변" Else Response.Write "답변완료" End if%></td>
					<%End If %>
					<td class="notice_date"		><%=work_date%></td>
				</tr>
		<%
			End If

			rs_n.movenext
		Loop
		rs_n.Close : Set rs_n = Nothing
		'----------------------------------------------------------------------- Top Notice E

		'----------------------------------------------------------------------- Main Article S

		rs.AbsolutePage = go_page								'해당 페이지의 첫번째 레코드로 이동한다
		Rcount			= rs.PageSize
		tempNo			= TotRecord-(go_page-1)*(Rcount)		'레코드번호로 사용할 임시번호

		cnt = 1
		Do While (Not rs.eof) And (Rcount > 0 )

			sid			= rs("sid")
			grp			= rs("grp")
			seq			= rs("seq")
			lev			= rs("lev")
			foreword	= rs("foreword")
			subject		= rs("subject")
				subject = cut_string(subject,50)
				If Not (IsNull(foreword)) Then subject = "[" & foreword & "]" & subject
			username	= rs("username")
			answer_status	= rs("answer_status")

			work_date	= rs("work_date")
			visit		= rs("visit")
			ip_addr		= rs("ip_addr")
			isSecret	= rs("isSecret")
			file1_name	= rs("file1_name")
			repl_badge	= ""
			bbs_cate	= rs("bbs_cate")

			If CInt(sid) <> CInt(grp) Then						'답변글 있을 경우 처리
				For i=1 To CInt(lev)
					repl_badge = repl_badge & "&nbsp;&nbsp;"
				Next
				repl_badge = repl_badge & "<img src='./img/icon_re_1.gif' border='0'>"
			End IF


				new_badge = ""
				if datediff("d",work_date,Date()) < 1 then	new_badge = "&nbsp;<img src='./img/icon_new_1.gif' align='top'>"

				If isSecret = "1" Then subject = "<img src='./img/icon_lock.gif' width='12' height='12' align='top'>&nbsp;" & subject
				subject		= "<span style=""cursor:pointer;"" onClick=""view_article('" & sid & "','" & isSecret & "');"">" & repl_badge & subject & new_badge & "</span>"

			'겔러리 일때 분류
			If bbs_Type ="G" Then
			%>
				<li>
					<dl>
						<dt><a href="#" onClick="view_article('<%=sid%>','<%=isSecret%>');"><img width="160px" height="160px" src="<%=file1_name%>"/></a></dt>
						<dd><a href="#"><%=subject%></a></dd>
						<dd><span class="g_name"><%=username%></span><span class="g_date"><%=work_date%></span></dd>
					</dl>
				</li>

			<%
			Else


		%>
			<tr class="list_tr" onMouseOver="this.className='list_tr_over';" onMouseOut="this.className='list_tr';">
				<td class="list_no"		><%=tempNo%>	</td>
				<td class="list_no"		><%=bbs_cate%>	</td>
				<td class="list_subject"><%=subject%>	</td>
				<%If bbs_type="P" Then%>
				<td class="list_writer"	><%If answer_status="0" Then Response.Write "미답변" Else Response.Write "답변완료" End if%></td>
				<%End If %>
				<td class="list_writer"	><%=username%>	</td>
				<td class="list_date"	><%=work_date%></td>
			</tr>
		<%
			End If
			cnt		= cnt + 1
			tempNo	= tempNo - 1
			Rcount	= Rcount - 1
			rs.MoveNext

		Loop
		rs.Close : Set rs = Nothing
		'----------------------------------------------------------------------- Main Article E
	End If
		'----------------------------------------------------------------------- Action Button S
	'겔러리 일때 분류
	If bbs_Type ="G" Then
	%>
		</ul>

	<table id="tbl_list" style="width:83%;margin:10px auto;text-align:right;" >
		<colgroup>
		<col width="100" />	<!-- 글번호 -->
		<col width="300" />	<!-- 글제목 -->
		<col width="300" />	<!-- 작성자 -->
		<col width="100" />	<!-- 등록일 -->
		</colgroup>
	<%
	Else%>

	<%
	End If
	%>



	<tr class="blank_tr"><td colspan="<%=colspanCnt%>"></td></tr>
	<tr>
		<td class="list_btn" colspan="<%=colspanCnt%>">
			<%

			If session("admin") <> "" Then
				Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./bbs_write.asp?" & Link_Str & "';"">"
			ElseIf write_level = "LOGIN" And session("userid") <> "" Then
				Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./bbs_write.asp?" & Link_Str & "';"">"
			ElseIf write_level = "COMMON" Then
				Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./bbs_write.asp?" & Link_Str & "';"">"
			End If

			%>
		</td>
	</tr>

	<%
	'----------------------------------------------------------------------- Page Number S
	If TotPage > 1 Then						'가져온 레코드의 갯수가 한 페이지 출력 갯수보다 많을 경우
	%>
	<tr class="blank_tr"><td colspan="4"></td></tr>

	<%
		gsize		= groupsize
		prev_page	= go_page - 1
		next_page	= go_page + 1
		end_page	= TotPage

		page_str= ""
		page_str= page_str &		"bbs_kind=" & bbs_kind
		page_str= page_str & "&" &	"srch_Key="	& srch_Key
		page_str= page_str & "&" &	"srch_Val="	& srch_Val
	%>
	<tr class="page_tr">
		<td class="page_td" colspan="4">
	<%
		If prev_page >= 1 Then
			Response.Write "<span class=""page_end""	onClick=""go_page('1');""				  title=""첫페이지"">◀</span>"
			Response.Write "<span class=""page_next""	onClick=""go_page('" & prev_page & "');"" title=""이전페이지"">이전</span>&nbsp;&nbsp;"
		Else
			Response.Write "<span class=""page_end""	onClick=""alert('첫페이지입니다.');""	  title=""첫페이지"">◀</span>"
			Response.Write "<span class=""page_next""	onClick=""alert('첫페이지입니다.');""	  title=""이전페이지"">이전</span>&nbsp;&nbsp;"
		End If

		L_Cnt	= gsize
		P_Cnt	= ((go_page-1) \ gsize) * gsize + 1

		Do While (L_Cnt > 0) and (P_Cnt <= TotPage)

		'현재 페이지의 색상 표현
			If P_Cnt = go_page Then
				Response.Write "<span class=""page_num_current"" onClick=""go_page('" & P_Cnt & "');"" title=""" & P_Cnt & """>" & P_Cnt & "</span>"
			Else
				Response.Write "<span class=""page_num_normal"" onClick=""go_page('" & P_Cnt & "');"" title=""" & P_Cnt & """  onMouseOver=""this.className='page_num_over';"" onMouseOut=""this.className='page_num_normal';"">" & P_Cnt & "</span>"
			End If

			Response.Write "<span class=""page_space""></span>"

			P_Cnt	= P_Cnt + 1
			L_Cnt	= L_Cnt - 1
		Loop

		If next_page <= TotPage Then
			Response.Write "&nbsp;&nbsp;<span class=""page_next""	onClick=""go_page('" & next_page & "');"" title=""다음페이지"">다음</span>"
			Response.Write "<span class=""page_end""	onClick=""go_page('" & TotPage   & "');"" title=""마지막페이지"">▶</span>"
		Else
			Response.Write "&nbsp;&nbsp;<span class=""page_next""	onClick=""alert('마지막페이지입니다');"" title=""다음페이지"">다음</span>"
			Response.Write "<span class=""page_end""	onClick=""alert('마지막페이지입니다');"" title=""마지막페이지"">▶</span>"
		End If

	%>
		</td>
	</tr>
	<%
	End If
	'----------------------------------------------------------------------- Page Number E
	%>
</table>


<div id="pass_input">
	<input type="hidden" id="pass_link">
	<input type="hidden" id="pass_sid">

	<table id="tbl_pass">
		<tr class="pop_top_tr">
			<td class="pop_top_left"></td>
			<td class="pop_top_mid"><img src="./img/btn_x.gif" alt="닫기" onClick="document.getElementById('scr_dimmer').style.display='none';document.getElementById('pass_input').style.display='none';" style="cursor:pointer;"/></td>
			<td class="pop_top_right"></td>
		</tr>
		<tr class="pop_body_tr">
			<td class="pop_body_left"></td>
			<td class="pop_body_mid">
				<table id="tbl_pass_main">
					<tr>
						<td class="pass_td">
							<% If session("admin") <> "" Then %>
							<ul style="text-align:left;">
								<li style="margin-left:-20px;">비밀글로 작성된 게시물입니다.</li>
								<li style="margin-left:-20px;">관리자 권한으로 게시물을 수정하실 경우 비밀글 상태를 변경하지않도록 주의해주십시오.</li>
							</ul>
							<span style="text-align:center;vertical-align:middle;"><img src="./img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();"></span>
							<input id="pass_chk" type="hidden" size="10" value="-----">
							<%	Else %>
							<ul style="text-align:left;">
								<li style="margin-left:-20px;">비밀글로 작성된 게시물입니다.</li>
								<li style="margin-left:-20px;">게시물을 열람하시려면 비밀번호를 입력하셔야 합니다.</li>
							</ul>
							<span style="text-align:center;vertical-align:middle;">비밀번호 : </span>
							<input id="pass_chk" type="password" size="10">
							<img src="./img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();">
							<%	End If %>
						</td>
					</tr>
				</table>
			</td>
			<td class="pop_body_right"></td>
		</tr>
		<tr class="pop_bottom_tr">
			<td class="pop_bottom_left"></td>
			<td class="pop_bottom_mid"></td>
			<td class="pop_bottom_right"></td>
		</tr>
	</table>
</div>

</body>

<script language=javascript>
function resize_height() {
	var h_size = document.body.scrollHeight;
	if (h_size < 500) { h_size = 600; }

	if(parent.document.getElementById("bbs_iframe")) {
		parent.document.getElementById("bbs_iframe").height = h_size;
	}
}

function view_article(a_id, a_lock) {
	var query	= "<%=link_str%>&sid=" + a_id + "&isSecret=" + a_lock;
	var url_	= "./bbs_view.asp?" + query;

	if (a_lock == '1') {
		var center_w = document.body.clientWidth;
		var center_h = document.body.clientHeight;
		var center_x = (window.pageXOffset) ?
			window.pageXOffset : (document.documentElement && document.documentElement.scrollLeft) ?
				document.documentElement.scrollLeft : (document.body) ? document.body.scrollLeft : 0;
		var center_y = (window.pageYOffset) ?
			window.pageYOffset : (document.documentElement && document.documentElement.scrollTop) ?
				document.documentElement.scrollTop : (document.body) ? document.body.scrollTop : 0;

		document.getElementById('scr_dimmer').style.width	= center_w + center_x;
		document.getElementById('scr_dimmer').style.height	= center_h + center_y;
		document.getElementById('scr_dimmer').style.display	= 'block';
		document.getElementById('pass_input').style.top		= "100px" //((center_h/2)+center_y) - 200;
		document.getElementById('pass_input').style.left	= "250px" //((center_w/2)+center_x) - 200;
		document.getElementById('pass_input').style.display	= 'block';
		document.getElementById('pass_link').value			= query;
		document.getElementById('pass_sid').value			= a_id;
	} else {
		location.href = url_;
	}
}

function go_page(p_num) {
	var url_ = "./bbs_list.asp?<%=Page_Str%>&go_page=" + p_num;
	location.href = url_;
}

function secret_article() {
	var pass = document.getElementById('pass_chk');
	if (pass.value == "") {
		alert('게시물 비밀번호를 입력해 주십시오.');
		pass.focus();
	} else {
		var query	= document.getElementById('pass_link').value + "&pass_chk=" + pass.value;
		var url_	= "./bbs_view.asp?" + query;
		location.href = url_;
	}
}
</script>
</html>