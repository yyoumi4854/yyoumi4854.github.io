<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual="/myoffice/common/bbs_common.inc" -->

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/bbs/css/bbs.css" rel="stylesheet" type="text/css">
</head>
<body onLoad="resize_height();" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
<%
srch_cate	= Request("srch_cate")
srch_key	= Request("srch_key")
srch_val	= Request("srch_val")

If srch_cate <> "" Then
	srch_sql = srch_sql & "and a.faq_cate = '" & srch_cate & "'	"
End If
If srch_val <> "" Then
	srch_sql = srch_sql & "and a." & srch_key & " = '" & srch_val & "'	"
End If
%>
<table id="tbl_search">
	<colgroup>
		<col width="930" />	<!-- 글번호 -->
	</colgroup>
	<tr>
		<td height="10"></td>
	</tr>
	<form name="search" method="post" action="./faq_list.asp">
	<tr>
		<td class="search_td" style="width:100%;padding:0px;">
			<b style="vertical-align:middle;">카테고리:</b>
			<select name="srch_cate" style="height:20px;vertical-align:middle;margin-right:10px;">
				<option value="">전체</option>
				<%
				sql =		"select	cate_cd, cate_kind, cate_name	"
				sql = sql & "  from	web_faq_cate					"
				sql = sql & " where	isuse = '1'						"
				sql = sql & "   and	cate_kind = 'FAQ'				"
				sql = sql & " order by cate_name					"
				Set rs = DBConn.Execute(sql)
				Do While Not rs.EOF
					If srch_cate = rs("cate_cd") Then
						strSelected = " selected"
					Else
						strSelected = ""
					End If
					Response.Write "<option value=""" & rs("cate_cd") & """" & strSelected & ">" & rs("cate_name") & "</option>"
					rs.MoveNext
				Loop
				%>
			</select>
			<select name="srch_key" style="height:20px;vertical-align:middle;">
				<option value="subject" <% If srch_key = "subject"	Then Response.Write "selected" %>>질문</option>
				<option value="content" <% If srch_key = "answer"	Then Response.Write "selected" %>>답변</option>
	        </select>

			<input NAME="srch_val" type="text" size="20" value="<%=srch_val%>" style="vertical-align:middle;">
			<img src="/bbs/img/btn_search.gif" style="cursor:pointer;border:0px;vertical-align:middle;" onClick="document.forms[0].submit();">
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
		<col width="100" />
		<col width="100" />
		<col width="430" />
		<col width="150" />
		<col width="150" />
	</colgroup>
	<tr class="header_tr">
		<td class="header_no"		>번호</td>
		<td class="header_no"		>카테고리</td>
		<td class="header_subject"	>FAQ 질문</td>
		<td class="header_writer"	>작성자</td>
		<td class="header_date"		>등록일</td>
	</tr>

	<%
	End If

	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.cursortype = 3
	sql =		"select /*+ INDEX_DESC*/ reg_no,						"
	sql = sql & "		a.faq_kind, faq_cate, subject, answer,			"
	sql = sql & "		a.work_user, file_name,							"
	sql = sql & "		b.cate_name,									"
	sql = sql & "		To_Char(a.work_date,'yyyy-mm-dd') as work_date	"
	sql = sql & "  from web_faq	a, web_faq_cate b						"
	sql = sql & " Where a.faq_cate = b.cate_cd							"
	sql = sql & srch_sql
	sql = sql & " order by reg_no desc									"
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
	%>
			<tr>
				<td colspan="4" class="no_list">등록된 게시물이 없습니다.</td>
			</tr>
	<%
	Else
		'----------------------------------------------------------------------- Main Article S

		rs.AbsolutePage = go_page								'해당 페이지의 첫번째 레코드로 이동한다
		Rcount			= rs.PageSize
		tempNo			= TotRecord-(go_page-1)*(Rcount)		'레코드번호로 사용할 임시번호

		cnt = 1
		Do While (Not rs.eof) And (Rcount > 0 )

			sid			= rs("reg_no")
			faq_kind	= rs("faq_kind")
			faq_cate	= rs("faq_cate")
			subject		= rs("subject")
				subject = cut_string(subject,50)
			answer		= rs("answer")
			work_user	= rs("work_user")
			work_date	= rs("work_date")
			file_name	= rs("file_name")
			cate_name	= rs("cate_name")

			subject		= "<span style=""cursor:pointer;"" onClick=""view_article('" & sid & "','" & isSecret & "');"">" & repl_badge & subject & new_badge & "</span>"
		%>
			<tr class="list_tr" onMouseOver="this.className='list_tr_over';" onMouseOut="this.className='list_tr';">
				<td class="list_no"		/><%=tempNo%>	</td>
				<td class="list_no"		/><%=cate_name%></td>
				<td class="list_subject"/><%=subject%>	</td>
				<td class="list_writer"	/><%=work_user%></td>
				<td class="list_date"	/><%=work_date%></td>
			</tr>
		<%
			cnt		= cnt + 1
			tempNo	= tempNo - 1
			Rcount	= Rcount - 1
			rs.MoveNext

		Loop
		rs.Close : Set rs = Nothing
		'----------------------------------------------------------------------- Main Article E
	End If
		'----------------------------------------------------------------------- Action Button S
	%>
	<tr class="blank_tr"><td colspan="5"></td></tr>
	<tr>
		<td class="list_btn" colspan="5">
			<button type="button" style="vertical-align:top;height:30px;" onclick="fnAddCate();">카테고리 관리</button>
			<%

			If session("admin") <> "" Then
				Response.Write "<img src=""../img/btn_save.gif"" style=""cursor:pointer;"" onClick=""location.href='./faq_write.asp?" & Link_Str & "';"">"
			ElseIf write_level = "LOGIN" And session("userid") <> "" Then
				Response.Write "<img src=""../img/btn_save.gif"" style=""cursor:pointer;"" onClick=""location.href='./faq_write.asp?" & Link_Str & "';"">"
			ElseIf write_level = "COMMON" Then
				Response.Write "<img src=""../img/btn_save.gif"" style=""cursor:pointer;"" onClick=""location.href='./faq_write.asp?" & Link_Str & "';"">"
			End If

			%>
		</td>
	</tr>

	<%
	'----------------------------------------------------------------------- Page Number S
	If TotPage > 1 Then						'가져온 레코드의 갯수가 한 페이지 출력 갯수보다 많을 경우
	%>
	<tr class="blank_tr"><td colspan="5"></td></tr>

	<%
		gsize		= groupsize
		prev_page	= go_page - 1
		next_page	= go_page + 1
		end_page	= TotPage

		page_str= ""
		page_str= page_str &		"srch_cate=" & srch_cate
		page_str= page_str & "&" &	"srch_Key="	& srch_Key
		page_str= page_str & "&" &	"srch_Val="	& srch_Val
	%>
	<tr class="page_tr">
		<td class="page_td" colspan="5">
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
			<td class="pop_top_mid"><img src="/bbs/img/btn_x.gif" alt="닫기" onClick="document.getElementById('scr_dimmer').style.display='none';document.getElementById('pass_input').style.display='none';" style="cursor:pointer;"/></td>
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
							<span style="text-align:center;vertical-align:middle;"><img src="/bbs/img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();"></span>
							<input id="pass_chk" type="hidden" size="10" value="-----">
							<%	Else %>
							<ul style="text-align:left;">
								<li style="margin-left:-20px;">비밀글로 작성된 게시물입니다.</li>
								<li style="margin-left:-20px;">게시물을 열람하시려면 비밀번호를 입력하셔야 합니다.</li>
							</ul>
							<span style="text-align:center;vertical-align:middle;">비밀번호 : </span>
							<input id="pass_chk" type="password" size="10">
							<img src="/bbs/img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();">
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
	var url_	= "./faq_modify.asp?" + query;

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
	var url_ = "./faq_list.asp?<%=Page_Str%>&go_page=" + p_num;
	location.href = url_;
}

function secret_article() {
	var pass = document.getElementById('pass_chk');
	if (pass.value == "") {
		alert('게시물 비밀번호를 입력해 주십시오.');
		pass.focus();
	} else {
		var query	= document.getElementById('pass_link').value + "&pass_chk=" + pass.value;
		var url_	= "./faq_modify.asp?" + query;
		location.href = url_;
	}
}

function fnAddCate(){
	location.href = "./faq_cate_list.asp";
}
</script>
</html>