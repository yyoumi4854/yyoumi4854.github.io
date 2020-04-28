<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0, minimal-ui">

<title>Untitled Document</title>
<link rel="stylesheet" type="text/css" href="/css/common.css" />

<link rel="stylesheet" type="text/css" href="/css/product.css" />
<link rel="stylesheet" type="text/css" href="/css/company.css" />
<link rel="stylesheet" type="text/css" href="/css/business.css" />
<link rel="stylesheet" type="text/css" href="/css/member.css" />
<link href="./css/bbs.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/responsive-tables.css">
<link rel="stylesheet" href="/css/magnific-popup.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.magnific-popup.js"></script>
<!-- <script type="text/javascript" src="js/nav.js"></script> -->
<script type="text/javascript" src="/js/matchMedia.js"></script>
<script type="text/javascript" src="/js/slick.min.js"></script>
<script type="text/javascript" src="/js/responsive-tables.js"></script>
<link rel="stylesheet" type="text/css" href="/css/slick.css" />
<link rel="stylesheet" type="text/css" href="/css/slick-theme.css" />
</head>
<body>
<!-- #include virtual="/common/common.inc" -->
<!-- #include virtual="/common/bbs_common.inc" -->

<%
pass_chk	= Request("pass_chk")
isSecret	= Request("isSecret")

If (isSecret = "1") And (write_level <> "ADMIN") And (session("admin") = "") Then
	sql = "select	NVL(passwd,'-') as pass from web_bbs where sid = " & sid
	Set rs_pass = DBConn.Execute(sql)

	If rs_pass("pass") <> pass_chk Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('비밀번호가 일치하지 않습니다.\n다시 확인해 주십시오.');"
		Response.Write "	history.back();"
		Response.Write "</script>"
		Response.End
	End If

	rs_pass.Close : Set rs_pass = Nothing
End If

Call update_cnt("sid", sid, "visit", "web_bbs")

sql =		"select	/*+ INDEX_DESC(web_bbs web_bbs_idx1)*/								"
sql = sql & "		'C' as position, sid, userid, username, foreword, subject, content,	"
sql = sql & "		file1_name, file2_name, file3_name, file4_name, file5_name,			"
sql = sql & "		visit, work_date, isSecret, ip_addr, tel, mobile, email				"
sql = sql & "  from	web_bbs																"
sql = sql & " where	bbs_kind = '" & bbs_kind & "'										"
sql = sql & "   and	sid = " & sid
sql = sql & "union all																	"
sql = sql & "select	/*+ INDEX_DESC(web_bbs web_bbs_idx1)*/								"
sql = sql & "		'P' as position, sid, userid, username, foreword, subject, content,	"
sql = sql & "		file1_name, file2_name, file3_name, file4_name, file5_name,			"
sql = sql & "		visit, work_date, isSecret, ip_addr, tel, mobile, email				"
sql = sql & "  from	web_bbs																"
sql = sql & " where	bbs_kind = '" & bbs_kind & "'										"
sql = sql & "   and	sid < " & sid
sql = sql & "   and	rownum = 1															"
sql = sql & "union all																	"
sql = sql & "select	/*+ INDEX_ASC(web_bbs web_bbs_idx1)*/								"
sql = sql & "		'N' as position, sid, userid, username, foreword, subject, content,	"
sql = sql & "		file1_name, file2_name, file3_name, file4_name, file5_name,			"
sql = sql & "		visit, work_date, isSecret, ip_addr, tel, mobile, email				"
sql = sql & "  from	web_bbs																"
sql = sql & " where	bbs_kind = '" & bbs_kind & "'										"
sql = sql & "   and sid > " & sid
sql = sql & "   and	rownum = 1															"
Set rs = Dbconn.Execute(sql)

prev_sid = ""	: prev_subject	= "<span style='color:#cacaca;'>이전 글이 없습니다.</span>"
next_sid = ""	: next_subject	= "<span style='color:#cacaca;'>다음 글이 없습니다.</span>"

Dim file_name(5), file_attach(5)

Do While Not rs.Eof

	Select Case rs("position")
	Case "C"										'-------------------------- 현재글
		userid		= rs("userid")
		username	= rs("username")
		visit		= rs("visit")
		foreword	= rs("foreword")
			If foreword <> "" Then
				foreword = "[" & foreword & "]"
			End If
		subject		= rs("subject")
		content		= rs("content")	: content = regularHTML(content)
'			content	= replace(content,"&#34;","""")
'			content	= replace(content,"<P>","")
'			content	= replace(content,"</P>","<br>")
'			content	= replace(content,"<p>","")
'			content	= replace(content,"</p>","<br>")
'			content	= replace(content,chr(13),"<br>")
		visit		= rs("visit")
		work_date	= rs("work_date")

		tel			= rs("tel")
		mobile		= rs("mobile")
		email		= rs("email")
		isSecret	= rs("isSecret")

		tel_str		= mobile	: If tel <> "" Then tel_str = tel & "&nbsp;&nbsp;/&nbsp;&nbsp;" & tel_str

		file_name(1)= rs("file1_name")
		file_name(2)= rs("file2_name")
		file_name(3)= rs("file3_name")
		file_name(4)= rs("file4_name")
		file_name(5)= rs("file5_name")

		file_cnt = 0
		For I=1 To 5
			If file_name(I) <> "" Then
				file_cnt = file_cnt + 1
				file_attach(file_cnt) = "&nbsp;<a href='" & file_name(I) & "' target='_blank'><img src='./img/file_icon.gif' align='bottom'>&nbsp;" & Right(file_name(I),Len(file_name(I))-InstrRev(file_name(I),"/"))
			End If
		Next
	Case "P"										'-------------------------- 이전글
		prev_sid	 = rs("sid")	: prev_subject	= rs("subject")	: isSecret	= rs("isSecret") : prev_subject = cut_string(prev_subject,50)
		prev_subject = "<span style=""cursor:pointer;"" onClick=""command_link('move','" & prev_sid & "','" & isSecret & "');"">" & prev_subject & "</span>"
	Case "N"
		next_sid	 = rs("sid")	: next_subject	= rs("subject")	: isSecret	= rs("isSecret") : next_subject = cut_string(next_subject,50)
		next_subject = "<span style=""cursor:pointer;"" onClick=""command_link('move','" & next_sid & "','" & isSecret & "');"">" & next_subject & "</span>"
	End Select

	rs.MoveNext
Loop
RS.Close : Set RS=nothing
%>

<div>

	<div >
    	<section class="sub_cont">
        	<div class="">
            	<div class="cont_s">
                    <div class="oder_cart_cont">

                    	<table id="table_content" border="0" cellspacing="0" cellpadding="0"  class="tb_common02 tb_oder_cart">
                            <tr>
                                <th class="txt_ct" style="width:130px;">글제목</td>
                                <td style="width:*;"><%=subject%></td>
                            </tr>
                            <tr>
                                <th class="txt_ct" >작성자</td>
                                <td ><%=username%></td>

                            </tr>
                            <tr>
                                <th class="txt_ct" >작성일시</td>
                                <td ><%=work_date%></td>

                            </tr>
							<% If file_cnt > 0 Then %>
							<tr>
                                <th class="txt_ct" >첨부자료</td>
                                <td >	<%
									For I=1 To UBound(file_attach)
										If file_attach(I) <> "" Then
											Response.Write file_attach(I)
											If I > 1 And I < UBound(file_attach) Then Response.Write "<br>"
										End If
									Next
									%>
								</td>
                            </tr>
							<% End If %>

							<% If bbs_type = "F" Then %>
							<tr>
                                <th class="txt_ct" >전화번호</td>
                                <td ><%=tel_str%></td>
                            </tr>
							<tr>
                                <th class="txt_ct" >E-Mail</td>
                                <td >
								<%=email%>
								</td>
                            </tr>
							<% End If %>

                            <tr>
                                <td colspan="2" style="width:100%; border-bottom:1px dotted #cacaca;padding-top:20px; padding-bottom:20px;">
								<div style="width:100%; border:none; overflow:hidden; overflow-x:auto;" >
								<%=content%>
								</div>
								</td>
                            </tr>
                        </table>


                    </div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="m_search_tb">
						<form name="search" method="post" action="./bbs_list_test.asp">
						<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">
						<colgroup>

							<col style="width:auto;">
							<col style="width:150px;">
						</colgroup>

						<tr class="command_tr">
							<td class="command_td_L" colspan="3">
								<% If session("admin") <> "" Or session("work_user") <> "" Or SESSION("userid") = userid then %>
									<img src="./img/btn_edit.gif" border="0" style="cursor:pointer;" onClick="command_link('edit','<%=sid%>');">&nbsp;&nbsp;
									<img src="./img/btn_del.gif"  border="0" style="cursor:pointer;" onClick="command_link('del','<%=sid%>');">
								<% End If %>
								<% If session("admin") <> "" And bbs_type = "Q" then %>
									&nbsp;&nbsp;<img src="./img/btn_reply.gif" border="0" style="cursor:pointer;" onClick="command_link('reply','<%=sid%>');">
								<% End If %>
							</td>
							<td class="command_td_R">
								<img src="./img/btn_list.gif" border="0" style="cursor:pointer;" onClick="command_link('list');">
							</td>
						</tr>
						</form>
					</table>

					<div id="pass_input">
						<input type="hidden" id="pass_link">
						<input type="hidden" id="pass_sid">
						<input type="hidden" id="work_mode">

						<table id="tbl_pass">
							<tr class="pop_top_tr">
								<td class="pop_top_left"></td>
								<td class="pop_top_mid"><img src="./img/btn_x.gif" alt="닫기" onclick="document.getElementById('scr_dimmer').style.display='none';document.getElementById('pass_input').style.display='none';" style="cursor:pointer;"/></td>
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
													<li style="margin-left:-20px;" id="noti_msg1"></li>
													<li style="margin-left:-20px;" id="noti_msg2"></li>
												</ul>
												<span style="text-align:center;vertical-align:middle;"><img src="./img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();"></span>
												<input id="pass_chk" type="hidden" size="10" value="-----">
												<%	Else %>
												<ul style="text-align:left;">
													<li style="margin-left:-20px;" id="noti_msg1"></li>
													<li style="margin-left:-20px;" id="noti_msg2"></li>
												</ul>
												<span style="text-align:center;vertical-align:middle;">비밀번호 : </span>
												<input id="pass_chk" type="password" size="10">
												<img src="./img/btn_check2.gif" style="cursor:pointer;" align="absmiddle" onClick="secret_article();">
												<% End If %>
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

	<script language="javascript">
		function resize_height()
		{
			var h_size = document.body.scrollHeight;
			if (h_size < 500) { h_size = 600; }

			if(parent.document.getElementById("bbs_iframe")) {
				parent.document.getElementById("bbs_iframe").height = h_size;
			}
		}

		function command_link(mode,a_id,a_lock) {
			if (mode == "list")	{
				parent.window.scrollTo(0,0);
				var query	= "<%=link_str%>";
				var url_	= "./bbs_list.asp?" + query;
				location.href = url_;
			}
			else if (mode == "reply")
			{
				parent.window.scrollTo(0,0);
				var query	= "<%=link_str%>";
				var url_	= "./bbs_reply.asp?" + query + "&sid=" + a_id;

				location.href = url_;
			}
			else if (mode == "move")
			{
				var query	= "<%=link_str%>";
				var url_	= "./bbs_view.asp?" + query + "&sid=" + a_id;

				if (a_lock == "1")
				{
					var center_w = document.body.clientWidth;
					var center_h = document.body.clientHeight;
					var center_x = (window.pageXOffset) ?
						window.pageXOffset : (document.documentElement && document.documentElement.scrollLeft) ?
							document.documentElement.scrollLeft : (document.body) ? document.body.scrollLeft : 0;
					var center_y = (window.pageYOffset) ?
						window.pageYOffset : (document.documentElement && document.documentElement.scrollTop) ?
							document.documentElement.scrollTop : (document.body) ? document.body.scrollTop : 0;

					document.getElementById('noti_msg1').innerHTML	= "비밀글로 작성된 게시물입니다.";
					document.getElementById('noti_msg2').innerHTML	= "게시물을 열람하시려면 비밀번호를 입력하셔야 합니다.";
					document.getElementById('work_mode').value		= "VIEW";
					document.getElementById('scr_dimmer').style.width	= center_w + center_x;
					document.getElementById('scr_dimmer').style.height	= center_h + center_y;
					document.getElementById('scr_dimmer').style.display	= 'block';
					document.getElementById('pass_input').style.top		= "100px" //((center_h/2)+center_y) - 200;
					document.getElementById('pass_input').style.left	= "250px" //((center_w/2)+center_x) - 200;
					document.getElementById('pass_input').style.display	= 'block';
					document.getElementById('pass_link').value			= query;
					document.getElementById('pass_sid').value			= a_id;
				}
				else
				{
					location.href = url_;
				}
			}
			else
			{
				var center_w = document.body.clientWidth;
				var center_h = document.body.clientHeight;
				var center_x = (window.pageXOffset) ?
					window.pageXOffset : (document.documentElement && document.documentElement.scrollLeft) ?
						document.documentElement.scrollLeft : (document.body) ? document.body.scrollLeft : 0;
				var center_y = (window.pageYOffset) ?
					window.pageYOffset : (document.documentElement && document.documentElement.scrollTop) ?
						document.documentElement.scrollTop : (document.body) ? document.body.scrollTop : 0;

				var query	= "<%=link_str%>" + "&sid=" + a_id + "&mode=" + mode;
				var conf_msg= "";

				if (mode == "edit") {
					conf_msg = "게시물을 수정하시겠습니까?";

					document.getElementById('noti_msg1').innerHTML	= "게시물 수정을 선택하셨습니다.";
					document.getElementById('noti_msg2').innerHTML	= "관리자 권한으로 게시물을 수정할 경우 비밀글 상태를 변경하지않도록 주의해 주십시오.";
				} else if (mode == "del") {
					conf_msg = "게시물을 삭제하시겠습니까?";
					document.getElementById('noti_msg1').innerHTML	= "게시물 삭제를 선택하셨습니다.";
					document.getElementById('noti_msg2').innerHTML	= "게시물을 삭제할 경우 다시 되살릴 수 없습니다. 삭제하시겠습니까?";
				}

				document.getElementById('scr_dimmer').style.width	= center_w + center_x;
				document.getElementById('scr_dimmer').style.height	= center_h + center_y;
				document.getElementById('scr_dimmer').style.display	= 'block';

				window.scrollTo(0,0);

				document.getElementById('pass_input').style.top		= "100px"; //((center_h/2)+center_y) - 150;
				document.getElementById('pass_input').style.left	= "200px"; //((center_w/2)+center_x) - 150;
				document.getElementById('pass_input').style.display	= 'block';
				document.getElementById('pass_link').value			= query;
				document.getElementById('pass_sid').value			= a_id;

				if ("<%=session("admin")%>" != "")	{
					document.getElementById('pass_input').style.display	= 'none';
					document.getElementById('scr_dimmer').style.display	= 'none';

					if (confirm(conf_msg))
					{
						secret_article();
					}
				}
			}
		}

		function secret_article() {
			var pass = document.getElementById('pass_chk');
			var work_mode = document.getElementById('work_mode').value;
			if (pass.value == "") {
				alert('게시물 비밀번호를 입력해 주십시오.');
				pass.focus();
			} else {
				var query	= document.getElementById('pass_link').value + "&pass_chk=" + pass.value;

				if (work_mode == "VIEW")
				{
					var url_	= "./bbs_view.asp?" + query;
				}
				else
				{
					var url_	= "./bbs_edit.asp?" + query;
				}

				location.href = url_;
			}
		}
		</script>
		<!-- 프레임 자동조절 스크립트  -->
		<script type="text/javascript" src="/js/iframeResizer.contentWindow.min.js"></script>
</div>
</body>
</html>