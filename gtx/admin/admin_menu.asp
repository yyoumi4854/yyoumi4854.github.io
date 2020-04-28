<!-- #include virtual ="/myoffice/common/common.inc" -->
<html>
<head>
<script language="javascript">
function menu(obj){

	var obj_id		= obj.getAttribute("id");
	var obj_sub		= obj.getAttribute("sub");
	var obj_url		= obj.getAttribute("url");
	var obj_title	= obj.innerText;
	var url_		= obj_url + "&title=" + obj_title;

	for(var i=1;i<20;i++) {
		if(document.getElementById("menu_"+ i + "_sub") && obj_sub != "N") {
			document.getElementById("menu_"+ i + "_sub").style.display = 'none';
		}
	}

	if (obj_sub != "T") {
		top.topFrame.location.href	= "./admin_title.asp?title=" + obj_title;
		top.RealFrame.location.href = obj_url;
	} else {
		document.getElementById(obj_id+"_sub").style.display = 'inline';
	}
}
</script>
</head>
<link href="./css/admin_style.css" rel="stylesheet"  type="text/css">
<style>
body {margin:15 0 0 0px;overflow-x:auto; overflow-y:auto;}
</style>

<body onLoad="menu(document.getElementById('menu_1'));">
<table width="228" height="100%" align="left" bgcolor="f2f2f2" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" valign="top">
			<table width="228" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height="100%" valign="top">
					<td align="center" valign="top" style="background:url(./img/menu_bg.gif); background-repeat:no-repeat; /">
						<!--메뉴시작-->
						<table width="220" align="center" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
							<tr>
								<td valign="top">
									<table width="200" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" >
										<tr>
											<td height="60"><img src="./img/lmn_title.jpg"></td>
										</tr>
										<tr><td height="8"></td></tr>
										<%
										sql =		"select	bbs_kind, bbs_name	"
										sql = sql & "  from web_bbs_cate		"
										sql = sql & " where	isUse = '1'			"
										sql = sql & " order by view_order		"
										Set rs = DBConn.Execute(sql)

										cnt = 1
										Do While Not rs.Eof
										%>
										<tr>
											<td height="27" background="./img/lmn_bg.jpg" class="mn_txt">
												<span	id="menu_<%=cnt%>" sub="F"
														url			= "/bbs/bbs_list.asp?bbs_kind=<%=rs("bbs_kind")%>"
														style		= "cursor:pointer;"
														onFocus		= "this.blur()"
														onMouseOver = "this.style.color='#ffff00';"
														onMouseOut  = "this.style.color='#ffffff';"
														onClick		= "menu(this);"><%=rs("bbs_name")%></span>
											</td>
										</tr>
										<tr><td height="5"></td></tr>
										<%
											cnt = cnt + 1
											rs.MoveNext
										Loop

										rs.Close : Set rs = Nothing
										%>
										<!-- 웹상품등록 -->
										<tr>
											<td height="27" background="./img/lmn_bg.jpg" class="mn_txt">
											<span	id="menu_11" sub="F"
													url			= "./product/product_product.asp"
													style		= "cursor:pointer;"
													onFocus		= "this.blur()"
													onMouseOver = "this.style.color='#ffff00';"
													onMouseOut  = "this.style.color='#ffffff';"
													onClick		= "menu(this);">웹제품등록</span>
											</td>
										</tr>
										<tr><td height="5"></td></tr>
										<!--// 웹상품등록 -->
										<!-- FAQ관리 -->
										<tr>
											<td height="27" background="./img/lmn_bg.jpg" class="mn_txt">
											<span	id="menu_11" sub="F"
													url			= "./faq/faq_list.asp"
													style		= "cursor:pointer;"
													onFocus		= "this.blur()"
													onMouseOver = "this.style.color='#ffff00';"
													onMouseOut  = "this.style.color='#ffffff';"
													onClick		= "menu(this);">FAQ 관리</span>
											</td>
										</tr>
										<tr><td height="5"></td></tr>
										<!--// FAQ관리 -->
									<% If Session("admin") = "mp_admin" Then%>
										<tr>
											<td height="27" background="./img/lmn_bg.jpg" class="mn_txt">
											<span	id="menu_11" sub="F"
													url			= "./admin_popup.asp"
													style		= "cursor:pointer;"
													onFocus		= "this.blur()"
													onMouseOver = "this.style.color='#ffff00';"
													onMouseOut  = "this.style.color='#ffffff';"
													onClick		= "menu(this);">팝업관리</span>
											</td>
										</tr>
										<tr><td height="5"></td></tr>

										<tr>
											<td height="27" background="./img/lmn_bg.jpg" class="mn_txt">
												<span	id="menu_10" sub="F"
														url			= "/admin/schedule_list.asp"
														style		= "cursor:pointer;"
														onFocus		= "this.blur()"
														onMouseOver = "this.style.color='#ffff00';"
														onMouseOut  = "this.style.color='#ffffff';"
														onClick		= "menu(this);">교육일정</span>
											</td>
										</tr>
										<tr><td height="5"></td></tr>
									<% End If %>
										<tr>
											<td height="27" background="./img/lmn_bg.jpg" class="mn_txt">
											<span	id="menu_11" sub="F"
													url			= "./admin_pass.asp"
													style		= "cursor:pointer;"
													onFocus		= "this.blur()"
													onMouseOver = "this.style.color='#ffff00';"
													onMouseOut  = "this.style.color='#ffffff';"
													onClick		= "menu(this);">관리자 비밀번호변경</span>
											</td>
										</tr>
										<!--
										<tr>
											<td valign="top">
												<table width="100%" border="0" cellspacing="0" cellpadding="0" ID="menu_11_sub">
													<tr>
														<td height="30" class="smn_txt">
															<span	id="menu_12" sub="N"
																	url			= "./admin_add.asp?bbs_kind=admin"
																	style		= "cursor:pointer;"
																	onFocus		= "this.blur()"
																	onMouseOver = "this.style.color='#0000cc';"
																	onMouseOut  = "this.style.color='#888787';"
																	onClick		= "menu(this);"><img src="./img/dot01.gif">계정추가</span>
														</td>
													</tr>
													<tr>
														<td height="30" class="smn_txt">
															<span	id="menu_13" sub="N"
																	url			= "./admin_pass.asp?bbs_kind=admin"
																	style		= "cursor:pointer;"
																	onFocus		= "this.blur()"
																	onMouseOver = "this.style.color='#0000cc';"
																	onMouseOut  = "this.style.color='#888787';"
																	onClick		= "menu(this);"><img src="./img/dot01.gif">비밀번호변경</span>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										-->
										<tr><td height="5"></td></tr>
										<tr>
											<td>
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td height="27"><a href="/" target="_blank" onFocus="this.blur();" ><img src="./img/lmn_home.gif" border="0"></a></td>
														<td width="2"><img src="./img/lmn_line.gif"></td>
														<td width="89"><img src="./img/lmn_logout.gif" width="89" height="27" border="0" style="cursor:pointer;" onClick="location.href='./logout.asp';"></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!--메뉴끝-->
</body>
</html>