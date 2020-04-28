<!--#include virtual="/myoffice/common/common.inc"-->
<%
If session("admin") <> "" Then
	Response.Redirect "./admin_frame.asp"
	Response.End
End If
%>
<html lang="ko">
<head>
<title>▒<%=session("company")%>관리자페이지</title>
<meta charset="utf-8">
<link href="./css/admin_style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function setPng24(obj) {
	obj.width=obj.height=1;
	obj.className=obj.className.replace(/\bpng24\b/i,'');
	obj.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ obj.src +"',sizingMethod='image');"
	obj.src='/img/blank.gif';
	return '';
}

function key_check(t) {
	if(t.keyCode == 13) frm_chk();
 }

function frm_chk() {

	var frm = document.req_frm;

	if (frm.LOGIN_ID.value == "") {
		alert(document.getElementById("LOGIN_ID").getAttribute("title"));
		document.getElementById("LOGIN_ID").focus();
		return false;
	} else if (frm.PASSWD.value == "") {
		alert(document.getElementById("PASSWD").getAttribute("title"));
		document.getElementById("PASSWD").focus();
		return false;
	} else {
		document.getElementById("btn_submit").style.display = 'none';
		frm.target = "proc_fr";
		frm.action = "./login_chk.asp";
		frm.submit();
	}
}
</script>
</head>
<style type="text/css">
body	{margin:0px;background:url(img/index_bg2.jpg) repeat-x center top;background-color:#f6f6f6;overflow-x:hidden;overflow-y:auto;}
.png24	{tmp:expression(setPng24(this));}
.bg		{background:url(./img/login_bg.png);background-repeat:no-repeat;}
</style>

<body onLoad="javascript:document.getElementById('LOGIN_ID').focus();">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="CENTER">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" valign="top">
				<tr>
					<td>
						<form name="req_frm" method="post" onSubmit="return frm_chk();">
							<table width="100%" align="center" height="350" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td align="center" valign="middle">
										<table width="467" border="0" cellspacing="0" cellpadding="0" style="margin-top:250px;">
											<tr>
												<td colspan="5">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="176"><img src="./img/login_title.png" class="png24"></td>
															<td>&nbsp;</td>
															<td width="240" valign="bottom" class="text02">*관리자 확인을 위해 로그인을 해주십시오.</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td width="100%">
													<table width="467" cellpadding="0" cellspacing="0" style="background:url(./img/login_bg.png); background-repeat:no-repeat;" >
														<tr>
															<td>
															<td height="116" width="200" align="left" valign="middle" style="padding-left:75px;" >
																<table width="200" border="0" cellpadding="0" cellspacing="5" class="text">
																	<tr>
																		<td width="70" align="right" class="Ltext2">관리자ID : </td>
																		<td align="left" width="100">
																			<input	type="text"
																					name="LOGIN_ID" id="LOGIN_ID"
																					title="관리자ID를 입력해 주십시오."
																					size="15" class="textbox01" style="width:100px;"
																					onKeyPress="key_check(event)">
																		</td>
																	</tr>
																	<tr>
																		<td width="70" align="right" class="Ltext2">비밀번호 : </td>
																		<td align="left" width="100">
																			<input	type="password"
																					name="PASSWD" id="PASSWD"
																					title="관리자 비밀번호를 입력해 주십시오."
																					size="15" class="textbox01" style="width:100px;"
																					onKeyPress="key_check(event)">
																		</td>
																	</tr>
																</table>
															</td>
															<td colspan="3" height="30"  align="center" >
																<img src="./img/btn_login2.gif" id="btn_submit" width="110" height="49" border="0" onclick="return frm_chk();">
															</td>
															<td>&nbsp;</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td align="center" valign="top" style="padding-top:30px;"><a href="/index.asp" onFocus="this.blur();">
													<img src="./img/btn_go.png" width="167" height="50" border="0" class="png24" /></a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</FORM>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
<iframe name="proc_fr" id="proc_fr" style="display:none;"></iframe>
</html>
