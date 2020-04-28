<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0, minimal-ui">

<title>Untitled Document</title>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/layout.css">
<link rel="stylesheet" href="/css/common.css">
<link rel="stylesheet" href="/css/subpage.css">
<link rel="stylesheet" href="/css/jquery-ui.css">
<link rel="stylesheet" href="/css/jquery.modal.css">
<link rel="stylesheet" href="/css/swiper.css">
<link rel="stylesheet" href="/css/font-awesome.css?">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.8.1/themes/base/jquery-ui.css" type="text/css" media="all">
<script src="/js/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
<script src="/js/common.js"></script>
<script src="/js/script.js"></script>
<script type="application/javascript" src="/js/iframeResizer.min.js"></script>
<style type="text/css">
	html,body{height:auto;}
</style>
</head>
<body>
<!-- #include virtual="/common/common.inc" -->
<!-- #include virtual="/common/bbs_common.inc" -->
<div>

	<div >
    	<section class="sub_cont">
        	<div class="">
            	<div class="cont_s">
                    <div class="customer_box">
						<!---------------------------- 검색 ----------------------->
						<form name="search" method="post" action="./bbs_resp_list.asp">
							<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">
							<div class="search_box">
								<select name="srch_key">
									<option value="name"	<% If srch_key = "name"		Then Response.Write "selected" %>>작성자</option>
									<option value="subject" <% If srch_key = "subject"	Then Response.Write "selected" %>>제목</option>
									<option value="content" <% If srch_key = "content"	Then Response.Write "selected" %>>내용</option>
								</select>
								<input type="text" name="srch_val" value="<%=srch_val%>" />
								<button type="button"  onClick="document.forms[0].submit();">검색</button>
							</div>
						</form>
					<table border="0" cellspacing="0" cellpadding="0" class="tb_oder_cart res_table">
							<thead class="mobile_hide_header">
							<tr>
                               <th scope="row" style="width:60px;">글번호</th>
                               <th scope="row" style="width:auto;">글제목</th>
							   <%
							   colCnt = "4"
							   If bbs_type="P" Then
									colCnt = "5"
							   %>
							   <th scope="row" style="width:100px;">답변여부</th>
							   <%End If %>
                               <th scope="row" style="width:100px">작성자</th>
                               <th scope="row" style="width:120px;">등록일</th>
                            </tr>
							</thead>
							<tbody>


						<%

						Set rs = Server.CreateObject("ADODB.RecordSet")
						rs.cursortype = 3
						sql =		"select /*+ INDEX_DESC(web_bbs web_bbs_idx1)*/			"
						sql = sql & "		sid, grp, seq, lev, foreword, subject, username,"
						sql = sql & "		To_Char(work_date,'yyyy-mm-dd') as work_date,	"
						sql = sql & "		isSecret, ip_addr, visit,file1_name	,answer_status			"
						sql = sql & "  from web_bbs											"
						sql = sql & " where	bbs_kind = '" & bbs_kind & "'					"
						If bbs_type = "P" And session("admin") <>"" Then
						sql = sql & "   and userid='"&session("userid")&"'					"
						End If
						IF Session("userid") = "" Then
						sql = sql & "   and	target = '0'									"
						End If
						sql = sql & srch_sql
						sql = sql & " order by grp desc, seq								"
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
									<td colspan="<%=colCnt%>" class="txt_ct">등록된 게시물이 없습니다.</td>

								</tr>
								<%


						Else
							'----------------------------------------------------------------------- Top Notice S

							Set rs_n = server.createobject("adodb.recordset")
							rs_n.cursortype = 3
								sql =		"select /*+ INDEX_DESC(web_bbs web_bbs_idx1)*/	"
								sql = sql & "		sid, grp, seq, lev, foreword, subject, username,"
								sql = sql & "		To_Char(work_date,'yyyy-mm-dd') as work_date,answer_status	"
								sql = sql & "  from	web_bbs											"
								sql = sql & " where bbs_kind = '" & bbs_kind & "'					"
								sql = sql & "   and top_noti ='1'									"
								If bbs_type = "P" And session("admin") <>"" Then
								sql = sql & "   and userid='"&session("userid")&"'					"
								End If
								IF Session("userid") = "" Then
								sql = sql & "   and	target = '0'									"
								End If
								sql = sql & " order by sid desc										"
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

								'겔러리 일때 분류

									new_badge = ""
									if datediff("d",work_date,Date()) < 1 then	new_badge = "<img src='./img/icon_new_1.gif' align='absmiddle'>"

									subject		= "<span style=""cursor:pointer;"" onClick=""view_article('" & sid & "','" & isSecret & "');"">" & subject & new_badge & "</span>"
							%>

								<tr>
									<td><img src="./img/btn_notice3.gif"></td>
									<td class="notice_title">
										<div class="mobile_hide"><%=subject%></div>
										<div class="mobile_show">
											<div><%=subject%></div>
											<div>
												<span><%=username%></span>
												<span><%=work_date%></span>
											</div>
										</div>
									</td>
									<td class="mobile_hide_cell"><%=username%></td>
									<td class="mobile_hide_cell"><%=work_date%></td>
								</tr>
							<%


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
								work_date	= rs("work_date")
								answer_status = rs("answer_status")
								visit		= rs("visit")
								ip_addr		= rs("ip_addr")
								isSecret	= rs("isSecret")
								file1_name	= rs("file1_name")
								repl_badge	= ""

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



							%>
								<tr>
									<td><%=tempNo%></td>
									<td class="notice_title">
										<div class="mobile_hide"><%=subject%></div>
										<div class="mobile_show">
											<div><%=subject%></div>
											<div>
												<span><%=username%></span>
												<span><%=work_date%></span>
												<%If bbs_type="P" Then %>
												<span><%If answer_status="0" Then Response.Write "미답변" Else Response.Write "답변완료" End if%></span>
											   <%End If %>
											</div>
										</div>
									</td>
								   <%If bbs_type="P" Then %>
									<td class="mobile_hide_cell"><%If answer_status="0" Then Response.Write "미답변" Else Response.Write "답변완료" End if%></td>
								   <%End If %>
									<td class="mobile_hide_cell"><%=username%></td>
									<td class="mobile_hide_cell"><%=work_date%></td>
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





							</tbody>
                        </table>
                    </div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="m_search_tb_btn">
						<form name="search" method="post" action="./bbs_resp_list.asp">
						<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">
						<colgroup>

							<col style="width:auto;">
							<col style="width:150px;">
						</colgroup>
						<tr>
							<td></td>
							<td>
							<%

							If session("admin") <> "" Then
								Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./bbs_resp_write.asp?" & Link_Str & "';"">"
							ElseIf write_level = "LOGIN" And session("userid") <> "" Then
								Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./bbs_resp_write.asp?" & Link_Str & "';"">"
							ElseIf write_level = "COMMON" Then
								Response.Write "<img src=""./img/btn_write.gif"" style=""cursor:pointer;"" onClick=""location.href='./bbs_resp_write.asp?" & Link_Str & "';"">"
							End If

							%>
							</td>
						</tr>
						</form>
					</table>

				<%
					'----------------------------------------------------------------------- Page Number S
					If TotPage > 1 Then						'가져온 레코드의 갯수가 한 페이지 출력 갯수보다 많을 경우
					%>
						<div class="page_num_area">
						<ul class="page_num_list">
					<%

						gsize		= groupsize
						prev_page	= go_page - 1
						next_page	= go_page + 1
						end_page	= TotPage

						page_str= ""
						page_str= page_str &		"bbs_kind=" & bbs_kind
						page_str= page_str & "&" &	"srch_Key="	& srch_Key
						page_str= page_str & "&" &	"srch_Val="	& srch_Val

						If prev_page >= 1 Then
							Response.Write "<li><a href=""#"" onClick=""go_page('1');""	title=""첫페이지""><img src=""../img/common/arrow_first_page.png"" /></a></li>"
							Response.Write "<li style=""margin-right:5px;""><a href=""#"" onClick=""go_page('" & prev_page & "');"" title=""이전페이지""><img src=""../img/common/arrow_prev_page.png"" /></a></li>"

						Else
							Response.Write "<li><a href=""#"" onClick=""alert('첫페이지입니다.');""	title=""첫페이지""><img src=""../img/common/arrow_first_page.png"" /></a></li>"
							Response.Write "<li style=""margin-right:5px;""><a href=""#"" onClick=""alert('첫페이지입니다.');"" title=""이전페이지""><img src=""../img/common/arrow_prev_page.png"" /></a></li>"

						End If

						L_Cnt	= gsize
						P_Cnt	= ((go_page-1) \ gsize) * gsize + 1

						Do While (L_Cnt > 0) and (P_Cnt <= TotPage)

						'현재 페이지의 색상 표현
							If P_Cnt = go_page Then
								Response.Write "<li><a href=""#"" onClick=""go_page('" & P_Cnt & "');"" title=""" & P_Cnt & """ class=""on"">" & P_Cnt & "</a></li>"
							Else
								Response.Write "<li><a href=""#"" onClick=""go_page('" & P_Cnt & "');"" title=""" & P_Cnt & """  onMouseOver=""this.className='page_num_over';"" onMouseOut=""this.className='page_num_normal';"">" & P_Cnt & "</a></li>"
							End If

							P_Cnt	= P_Cnt + 1
							L_Cnt	= L_Cnt - 1
						Loop

						If next_page <= TotPage Then
							Response.Write "<li style=""margin-left:5px;""><a href=""#"" onClick=""go_page('" & next_page & "');"" title=""다음페이지""><img src=""../img/common/arrow_next_page.png"" /></a></li>"
							Response.Write "<li><a href=""#"" onClick=""go_page('" & TotPage   & "');"" title=""마지막페이지""><img src=""../img/common/arrow_last_page.png"" /></a></li>"

						Else
							Response.Write "<li style=""margin-left:5px;""><a href=""#"" onClick=""alert('마지막페이지입니다');"" title=""다음페이지""><img src=""../img/common/arrow_next_page.png"" /></a></li>"
							Response.Write "<li><a href=""#"" onClick=""alert('마지막페이지입니다');"" title=""마지막페이지""><img src=""../img/common/arrow_last_page.png"" /></a></li>"
						End If

					%>
							</ul>
						</div>
					<%
					End If
					'----------------------------------------------------------------------- Page Number E
					%>
				<div id="pass_input" style="display:none;">
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
												<li>비밀글로 작성된 게시물입니다.</li>
												<li>관리자 권한으로 게시물을 수정하실 경우 비밀글 상태를 변경하지않도록 주의해주십시오.</li>
											</ul>
											<span><img src="./img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();"></span>
											<input id="pass_chk" type="hidden" size="10" value="-----">
											<%	Else %>
											<ul>
												<li>비밀글로 작성된 게시물입니다.</li>
												<li>게시물을 열람하시려면 비밀번호를 입력하셔야 합니다.</li>
											</ul>
											<span>비밀번호 : </span>
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


                </div>
            </div>
        </section>
    </div>

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
		var url_	= "./bbs_resp_view.asp?" + query;

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
		var url_ = "./bbs_resp_list.asp?<%=Page_Str%>&go_page=" + p_num;
		location.href = url_;
	}

	function secret_article() {
		var pass = document.getElementById('pass_chk');
		if (pass.value == "") {
			alert('게시물 비밀번호를 입력해 주십시오.');
			pass.focus();
		} else {
			var query	= document.getElementById('pass_link').value + "&pass_chk=" + pass.value;
			var url_	= "./bbs_resp_view.asp?" + query;
			location.href = url_;
		}
	}
	</script>
		<!-- 프레임 자동조절 스크립트  -->
		<script type="text/javascript" src="/js/iframeResizer.contentWindow.min.js"></script>
</div>
</body>
</html>