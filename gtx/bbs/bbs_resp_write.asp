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
	<script type="text/javascript" src="/bbs/NEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	<script>
	$(document).ready(function() {
		resize_height();

	});
	</script>

<%
If SESSION("work_user") <> "" Then										'--- ERP 관리자페이지가 있을 경우 Work_User가 Admin
	userid = SESSION("work_user")	: username = SESSION("work_user")	: class_name = "input_read"
ElseIf session("admin") <> "" Then										'--- ERP가 아닌 웹에서 /admin으로 접속한 경우
	userid = session("admin")		: username = "관리자"				: class_name = "input_read"
ElseIf session("userid") <> "" Then										'--- 일반 홈페이지에서 회원 로그인한 경우
	userid = session("userid")		: username = session("username")	: class_name = "input_read"
ElseIf write_level = "COMMON" Then
	userid = "guest"		: username = ""								: class_name = "input"
Else
	Response.Write "<script language='javascript'>"
	Response.Write "	alert('정상적인 접근이 아닙니다.');"
	Response.Write "	history.back();"
	Response.Write "</script>"
	Response.End
End If
%>

<div>

	<div>
    	<section class="sub_cont">
        	<div class="">
            	<div class="cont_s">
                    <div class="oder_cart_cont">
						<form method="post" name="reg_frm" enctype="multipart/form-data" onsubmit="frm_chk();">
						<input type="hidden" name="go_chk">
						<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">
						<input type="hidden" name="ip_addr"  value="<%=Request.ServerVariables("remote_addr")%>">

                    	<table id="table_content" border="0" cellspacing="0" cellpadding="0"  class="tb_common02 tb_oder_cart">
                            <tr>
                                <th class="txt_ct" style="width:130px;">작성자ID</td>
                                <td style="text-align:left; padding-left:10px;">
											<input	type="text" class="input_read"
											name="userid" id="userid"
											check="T" check_type="length" check_length="0" check_key=""
											title="작성자ID를 입력해 주십시오."
											value="<%=userid%>">
								</td>
                            </tr>
                            <tr>
                                <th class="txt_ct" >작성자</td>
                                <td style="text-align:left; padding-left:10px;" >
								<input	type="text" class="<%=class_name%>"
										name="username" id="username"
										title="작성자 이름을 입력해 주십시오."
										check="T" check_type="length" check_length="0" check_key=""
										value="<%=username%>">
								</td>

                            </tr>
                            <tr>
                                <th class="txt_ct" >글제목</td>
                                <td style="text-align:left; padding-left:10px;" >
									<input	type="text"
											name="subject" id="subjecct"
											check="T" check_type="length" check_length="0" check_key=""
											title="글제목을 입력해 주십시오."
											class="input" style="width:500px;">
								</td>

                            </tr>
                            <tr>
                                <th class="txt_ct" >글내용</td>
                                <td >
								<textarea	id="msg_body" name="msg_body"
											check="T" check_type="length" check_length="0" check_key=""
											title="글내용을 입력해 주십시오."
											style="display:none;height:100px;"><%=contents%></textarea>
								</td>

                            </tr>

							<tr class="write_tr">
									<th class="txt_ct">비밀번호</td>
									<td class="write_td_colspan" style="text-align:left; padding-left:10px;">
										<input	type="password"
												name="passwd" id="passwd"
												title="글삭제, 수정을 위해 비밀번호를 입력해 주십시오."
												check="T" check_type="length" check_length="0" check_key="">&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="isSecret" value="1" style="border:none;"> 비밀글
									</td>
								</tr>
								<tr class="write_tr">
									<th class="txt_ct"><%If bbs_Type = "G" Then
									%>이미지파일<%
									Else
										%>첨부파일<%
									End If
									%>
									</td>
									<td class="write_td_colspan" style="text-align:left; padding-left:10px;" >
										<input type="file" name="upfile" style="width:400px;">
									</td>
								</tr>
								<tr class="submit_tr">
									<td colspan="2" class="submit_td">
										<div id="btn_submit" style="diplay:inline;">
										<img src="./img/btn_complete.gif"	style="cursor:pointer;" onClick="frm_chk();">&nbsp;&nbsp;&nbsp;&nbsp;
										<img src="./img/btn_cancel.gif"		style="cursor:pointer;" onClick="javascript:history.back();">
										</div>
									</td>
								</tr>
                        </table>
						</form>
					</div>

                </div>
            </div>
        </section>
    </div>
	<iframe name="proc_fr" id="proc_fr" style="width:600px;height:200px;display:none;"></iframe>
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
				var url_	= "./bbs_resp_list.asp?" + query;
				location.href = url_;
			}
			else if (mode == "reply")
			{
				parent.window.scrollTo(0,0);
				var query	= "<%=link_str%>";
				var url_	= "./bbs_resp_reply.asp?" + query + "&sid=" + a_id;

				location.href = url_;
			}
			else if (mode == "move")
			{
				var query	= "<%=link_str%>";
				var url_	= "./bbs_resp_view.asp?" + query + "&sid=" + a_id;

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

		</script>
		<script type="text/javascript">
		//---------------------------------------------------------------------- EDITOR INSERT START
		var oEditors = [];

		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];		// 추가 글꼴 목록
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "msg_body",
			sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
				}
			}, //boolean
			fOnAppLoad : function(){
				//예제 코드
				//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
			},
			fCreator: "createSEditor2"
		});

		//---------------------------------------------------------------------- EDITOR INSERT END
		</script>

		<script language="javascript">
		var frm = document.reg_frm;

		function frm_chk() {

			var proc_ok = "T";

			oEditors.getById["msg_body"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.

			for (i=0;i<frm.length;i++) {

				var field_check = frm.elements[i].getAttribute("check");
				var field_type	= frm.elements[i].getAttribute("check_type");
				var field_length= frm.elements[i].getAttribute("check_length");
				var field_key	= frm.elements[i].getAttribute("check_key");
				var	field_alert	= frm.elements[i].getAttribute("title");
				var field_value	= frm.elements[i].value;

				if (field_check == "T") {
					if (field_type == "length")	{
						if (field_value.length <= Number(field_length))	{
							alert(field_alert);
							frm.elements[i].focus();
							proc_ok = "F";
							return false;
						}
					}
				}
			}

		/*
			if(document.getElementById('org_body').value == "<P>&nbsp;</P>" || document.getElementById('org_body').value == "" ){
				alert("글내용을 입력해주십시오.");
				document.getElementById('org_body').focus();
				proc_ok = "F";
				return false;
			}
		*/

			if (proc_ok == "T")	{
				document.getElementById("btn_submit").style.display = "none";
				frm.target	="proc_fr";
				frm.action	= "./bbs_write_ok.asp";
				frm.submit();
			}
		}

		function resize_height() {
			var h_size = document.body.scrollHeight;

			if (h_size < 500) { h_size = 600; }

			if(parent.document.getElementById("bbs_iframe")) {
				parent.document.getElementById("bbs_iframe").height = h_size;
			}
		}
		</script>
		<!-- 프레임 자동조절 스크립트  -->
		<script type="text/javascript" src="/js/iframeResizer.contentWindow.min.js"></script>
</div>
</body>
</html>