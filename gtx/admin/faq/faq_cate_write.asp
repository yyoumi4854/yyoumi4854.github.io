<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<%

Response.ContentType="text/html"
Response.charset = "utf-8"
Session.CodePage=65001
%>
<html>
<head>
	<title><%=session("company")%></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>

	<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" media="all" />
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
	<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="/bbs/NEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	<script>
	$(document).ready(function() {
		resize_height();
		$("#st_date, #ed_date").datepicker({
		    //"" or "button" 입력필드 옆에 아래 지정한 아이콘 표시	showOn: "",
			buttonImage: "/common/img/find_btn_cal.gif",
			buttonImageOnly: true,
			showButtonPanel: false,									//달력 하단의 종료와 오늘 버튼 Show
			showAnim:"",											// 달력 에니메이션 ( show(default),slideDown,fadeIn,blind,bounce,clip,drop,fold,slide,"")
			monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			dateFormat : "yy-mm-dd"
		});
	});
	</script>
</head>
<link rel="stylesheet" href="/bbs/css/bbs.css" type="text/css" />

<%
If SESSION("work_user") <> "" Then										'--- ERP 관리자페이지가 있을 경우 Work_User가 Admin
	userid = SESSION("work_user")	: username = SESSION("work_user")	: class_name = "input_read"
ElseIf session("admin") <> "" Then										'--- ERP가 아닌 웹에서 /admin으로 접속한 경우
	userid = session("admin")		: username = "관리자"				: class_name = "input_read"
ElseIf session("userid") <> "" Then										'--- 일반 홈페이지에서 회원 로그인한 경우
	userid = session("userid")		: username = session("user_name")	: class_name = "input_read"
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
<body>

<table class="tbl_write">
	<form method="post" name="reg_frm"  onsubmit="frm_chk();">
	<input type="hidden" name="ip_addr"  value="<%=Request.ServerVariables("remote_addr")%>">
<%
'in bbs_common.inc

Function typeWriteTablePop(bType)
	strWriteTable = ""

		'기본형
		strWriteTable =				  "	<colgroup>						"
		strWriteTable = strWriteTable & "		<col width='100' />			"
		strWriteTable = strWriteTable & "		<col width='260' />			"
		strWriteTable = strWriteTable & "		<col width='100' />			"
		strWriteTable = strWriteTable & "		<col width='260' />			"
		strWriteTable = strWriteTable & "	</colgroup>						"

	typeWriteTablePop = strWriteTable
End Function

Response.Write typeWriteTablePop(bbs_type)
%>


	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">작성자ID</td>
		<td class="write_td_content">
			<input	type="text" class="input_read"
					name="userid" id="userid"
					check="T" check_type="length" check_length="0" check_key=""
					title="작성자ID를 입력해 주십시오."
					value="<%=userid%>">
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">작성자이름</td>
		<td class="write_td_content">
			<input	type="text" class="<%=class_name%>"
					name="username" id="username"
					title="작성자 이름을 입력해 주십시오."
					check="T" check_type="length" check_length="0" check_key=""
					value="<%=username%>">
		</td>
	</tr>
	<tr class="line_tr"><td class="line_td" colspan="4"></td></tr>

	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">카테고리 코드</td>
		<td class="write_td_content">
			<input type="text" name="cate_cd" id="cate_cd" maxlength="4"
					check="T" check_type="length" check_length="0" check_key="" />
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">카테고리 이름</td>
		<td class="write_td_content">
			<input type="text" name="cate_name" id="cate_name"
					check="T" check_type="length" check_length="0" check_key="" />
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">분류</td>
		<td class="write_td_content">
			<input type="text" name="cate_kind" id="cate_kind" value="FAQ"
					check="T" check_type="length" check_length="0" check_key="" />
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">카테고리 사용</td>
		<td class="write_td_colspan">
			<select name="isuse" id="isuse" style="width:70%;">
				<option value="1">사용</option>
				<option value="0">미사용</option>
			</select>
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">표시순서</td>
		<td class="write_td_content" colspan="3">
			<input type="text" name="order_view" id="order_view" value="" />
		</td>
		<!--
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">-</td>
		<td class="write_td_colspan">
			&nbsp;
		</td>
		-->
	</tr>
	<tr class="line_tr"><td class="line_td" colspan="4"></td></tr>

	<tr class="submit_tr">
		<td colspan="4" class="submit_td">
			<div id="btn_submit" style="diplay:inline;">
			<img src="../img/btn_complete.gif"	style="cursor:pointer;" onClick="frm_chk();">&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="/bbs/img/btn_cancel.gif"	style="cursor:pointer;" onClick="javascript:history.back();">
			</div>
		</td>
	</tr>

	</form>
</table>

<!-- display:none; -->
<iframe name="proc_fr" id="proc_fr" style="width:600px;height:200px;display:dnone;"></iframe>
</body>

<script language="javascript">
var frm = document.reg_frm;

function frm_chk() {

	var proc_ok = "T";

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
		frm.action	= "./faq_cate_write_ok.asp";
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

</html>