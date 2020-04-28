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

cate_cd = Request("sid")

	sql =		"select /*+ INDEX_DESC*/									"
	sql = sql & "		a.cate_cd, a.cate_kind, a.cate_name,				"
	sql = sql & "		a.work_user, a.cate_img, a.parent_cd,				"
	sql = sql & "		a.cate_name, a.order_view, a.isuse,					"
	sql = sql & "		decode(a.isuse, '1', '사용', '사용안함') as isuses,	"
	sql = sql & "		To_Char(a.work_date,'yyyy-mm-dd') as work_date		"
	sql = sql & "  from web_faq_cate a										"
	sql = sql & " Where a.cate_cd = '" & cate_cd & "'						"
	Set rs = DBConn.Execute(sql)
	cate_cd		= rs("cate_cd")
	cate_kind	= rs("cate_kind")
	parent_cd	= rs("parent_cd")
	cate_name	= rs("cate_name")
	cate_img	= rs("cate_img")
	isuse		= rs("isuse")
	isuses		= rs("isuses")
	work_date	= rs("work_date")
	work_user	= rs("work_user")
	order_view	= rs("order_view")
	rs.Close	: Set rs = Nothing
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
			<input type="text" name="cate_cd" id="cate_cd" maxlength="4" value="<%=cate_cd%>" class="input_read" readonly
					check="T" check_type="length" check_length="0" check_key="" />
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">카테고리 이름</td>
		<td class="write_td_content">
			<input type="text" name="cate_name" id="cate_name" value="<%=cate_name%>"
					check="T" check_type="length" check_length="0" check_key="" />
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">분류</td>
		<td class="write_td_content">
			<input type="text" name="cate_kind" id="cate_kind" value="<%=cate_kind%>"
					check="T" check_type="length" check_length="0" check_key="" />
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">카테고리 사용</td>
		<td class="write_td_colspan">
			<select name="isuse" id="isuse" style="width:70%;">
				<option value="1">사용</option>
				<option value="0">미사용</option>
			</select>
			<script>$("#isuse").val("<%=isuse%>");</script>
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">표시순서</td>
		<td class="write_td_content" colspan="3">
			<input type="text" name="order_view" id="order_view" value="<%=order_view%>" />
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
			<img src="../img/btn_complete.gif"	style="cursor:pointer;" onClick="frm_chk();">
			<img src="/bbs/img/btn_cancel.gif"	style="cursor:pointer;margin-left: 40px;" onClick="javascript:history.back();">
			<img src="/bbs/img/btn_del.gif"	style="cursor:pointer;margin-left: 40px;" onClick="fnThisDel();">
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

	if (proc_ok == "T")	{
		document.getElementById("btn_submit").style.display = "none";
		frm.target	="proc_fr";
		frm.action	= "./faq_cate_modify_ok.asp";
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

function fnThisDel(){
	if (confirm("삭제 하시겠습니까?")){
		document.getElementById("btn_submit").style.display = "none";
		frm.target	="proc_fr";
		frm.action	= "./faq_cate_del_ok.asp";
		frm.submit();
	}
}
</script>

</html>