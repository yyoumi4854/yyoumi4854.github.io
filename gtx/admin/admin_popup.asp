<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/function.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<%
Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/bbs/css/bbs.css" rel="stylesheet" type="text/css">
</head>
<body onLoad="resize_height();">

<table id="tbl_search">
<%

colCount="7"
Function  typeWriteTablePop(bType,defaultTableWidth)
	strTableWidh = ""

	defaultTableWidth="950"
		'기본형
		strTableWidh =				  "	<colgroup>						"
		strTableWidh = strTableWidh & "	<col width="&defaultTableWidth&" />	"
		strTableWidh = strTableWidh & "	</colgroup>						"


	typeWriteTablePop = strTableWidh

End Function

Response.Write  typeWriteTablePop(bbs_Type,tableWidth)
%>
	<tr>
		<td height="10"></td>
	</tr>
	<form name="search" method="post" action="./bbs_list.asp">
	<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">


	<tr>
		<td class="search_td" style="width:100%;padding:0px;">
		<a href="#"  onclick='popPreview();'>[미리보기]</a>
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

	Function  typeTitle(bType)
		strHead = ""

			'기본형
			strHead =			"<table id='tbl_list'>											"
			strHead = strHead & "	<colgroup>													"
			strHead = strHead & "		<col width='100' />										"
			strHead = strHead & "		<col width='330' />										"
			strHead = strHead & "		<col width='100' />										"
			strHead = strHead & "		<col width='100' />										"
			strHead = strHead & "		<col width='100' />										"
			strHead = strHead & "		<col width='100' />										"
			strHead = strHead & "		<col width='100' />										"
			strHead = strHead & "	</colgroup>													"
			strHead = strHead & "	<tr class='header_tr'>										"
			strHead = strHead & "		<td class='header_no'		/>번호</td>					"
			strHead = strHead & "		<td class='header_subject'	/>팝업제목</td>				"

			strHead = strHead & "		<td class='header_date'		/>게시상태</td>				"
			strHead = strHead & "		<td class='header_date'		/>게시타입</td>				"
			strHead = strHead & "		<td class='header_date'		/>시작일</td>				"
			strHead = strHead & "		<td class='header_date'		/>종료일</td>				"
			strHead = strHead & "	</tr>														"


		typeTitle = strHead

	End Function
	Function  typeNoItem(bType)
		strNoItem = ""

			'기본형
			strNoItem =				"<tr>															"
			strNoItem = strNoItem & "<td colspan='"&colCount&"' class='no_list'>등록된 팝업이 없습니다.</td>	"
			strNoItem = strNoItem & "</tr>															"


		typeNoItem = strNoItem

	End Function
	Function  typeListItem(bType,sid,subject,tempNo,sPopup_status,sIsUseDate,sSt_date,sEd_date)
		'메인글 리스트
		strListItemReply = ""

			'기본형

			strListItemReply = "				   <tr class='list_tr' onMouseOver=""this.className='list_tr_over';"" onMouseOut=""this.className='list_tr';"">"
			strListItemReply = strListItemReply & "	<td class='list_no'		/>"&tempNo&"	</td>															   "
			strListItemReply = strListItemReply & "	<td class='list_subject'/>"&subject&"	</td>															   "
			strListItemReply = strListItemReply & "	<td class='list_writer'	/>"&sPopup_status&"	</td>															   "
			strListItemReply = strListItemReply & "	<td class='list_date'	/>"&sIsUseDate&" </td>															   "
			strListItemReply = strListItemReply & "	<td class='list_date'	/>"&sSt_date&" </td>															   "
			strListItemReply = strListItemReply & "	<td class='list_date'	/>"&sEd_date&" </td>															   "
			strListItemReply = strListItemReply & "</tr>																									   "

		typeListItem = strListItemReply

	End Function

Function  typeEnd(bType)
		strEnd = ""
		If bType = "G" Then
			strEnd =		  "</ul>																		 "
			strEnd = strEnd & "	<table id='tbl_list' style=""width:83%;margin:10px auto;text-align:right;"" >"
			strEnd = strEnd & "		<colgroup>																 "
			strEnd = strEnd & "		<col width='100' />													  	 "
			strEnd = strEnd & "		<col width='300' />													  	 "
			strEnd = strEnd & "		<col width='300' />													  	 "
			strEnd = strEnd & "		<col width='100' />													  	 "
			strEnd = strEnd & "		</colgroup>																 "

		Else

		End If
		typeEnd = strEnd

	End Function



	Response.WRite typeTitle(bbs_type)

	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.cursortype = 3
	sql =		"select * From web_popup_L "

	sql = sql & srch_sql
	sql = sql & " order by REGNO desc "

	'Response.WRite sql
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
		Response.Write typeNoItem(bbs_type)

	Else

		'----------------------------------------------------------------------- Main Article S

		rs.AbsolutePage = go_page								'해당 페이지의 첫번째 레코드로 이동한다
		Rcount			= rs.PageSize
		tempNo			= TotRecord-(go_page-1)*(Rcount)		'레코드번호로 사용할 임시번호

		cnt = 1
		Do While (Not rs.eof) And (Rcount > 0 )

			sid			= rs("regno")
			subject		= rs("title")

			subject = cut_string(subject,50)
			isuse	= rs("isuse")
			popup_status	= rs("POPUP_STATUS")
			isusedate	= rs("isusedate")

			st_date	= rs("st_date")
			ed_date	= rs("ed_date")
			If isusedate="0" Then strIsusedate = "일반" Else strIsusedate = "기간" End If
			If popup_status="0" Then
				strPopup_status = "보류"
			ElseIf popup_status="1"  Then
				strPopup_status = "게시"
			Else
				strPopup_status = "종료"
			End If

			If st_date="" Or IsNull(st_date) Then st_date= "-" End If
			If ed_date="" Or IsNull(ed_date) Then ed_date= "-" End If

			repl_badge	= ""

				new_badge = ""
				if datediff("d",work_date,Date()) < 1 then	new_badge = "&nbsp;<img src='./img/icon_new_1.gif' align='top'>"

				If isSecret = "1" Then subject = "<img src='./img/icon_lock.gif' width='12' height='12' align='top'>&nbsp;" & subject
				subject		= "<span style=""cursor:pointer;"" onClick=""view_article('" & sid & "','" & isSecret & "');"">" & repl_badge & subject & new_badge & "</span>"


			'메인글 리스트 호출
			 Response.WRite typeListItem(bbs_Type,sid,subject,tempNo,strPopup_status,strIsusedate,st_date,ed_date)

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

	Response.Write typeEnd(bbs_Type)

	%>



	<tr class="blank_tr"><td colspan="<%=colCount%>"></td></tr>
	<tr>
		<td class="list_btn" colspan="<%=colCount%>">
			<%

				Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./admin_popup_write.asp?" & Link_Str & "';"">"

			%>
		</td>
	</tr>

	<%
	'----------------------------------------------------------------------- Page Number S
	If TotPage > 1 Then						'가져온 레코드의 갯수가 한 페이지 출력 갯수보다 많을 경우
	%>
	<tr class="blank_tr"><td colspan="<%=colCount%>"></td></tr>

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
	var url_	= "./admin_popup_edit.asp?" + query;


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
		var url_	= "./admin_popup_edit.asp?" + query;
		location.href = url_;
	}
}
function popPreview(){
	alert('게시상태가 [보류]인 팝업만 보입니다.');
	window.open('/index_preview.asp','winPreview','');

}
</script>
</html>