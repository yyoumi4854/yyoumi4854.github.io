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
	userid = Session("work_user")	: username = SESSION("work_user")	: class_name = "input_read"
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

reg_no = Request("sid")

	sql =		"select /*+ INDEX_DESC*/ reg_no,						"
	sql = sql & "		a.faq_kind, faq_cate, subject, answer,			"
	sql = sql & "		a.work_user, file_name,							"
	sql = sql & "		b.cate_name, a.isuse, pdt_cate,					"
	sql = sql & "		To_Char(a.work_date,'yyyy-mm-dd') as work_date	"
	sql = sql & "  from web_faq	a, web_faq_cate b						"
	sql = sql & " Where a.faq_cate = b.cate_cd							"
	sql = sql & "   and	a.reg_no = " & reg_no
	Set rs = DBConn.Execute(sql)
	reg_no		= rs("reg_no")
	faq_kind	= rs("faq_kind")
	faq_cate	= rs("faq_cate")
	subject		= rs("subject")
	answer		= rs("answer")
	isuse		= rs("isuse")
	pdt_cate	= rs("pdt_cate")
	rs.Close	: Set rs = Nothing

%>
<body>

<table class="tbl_write">
	<form method="post" name="reg_frm"   enctype="multipart/form-data" onsubmit="frm_chk();">
	<input type="hidden" name="ip_addr"  value="<%=Request.ServerVariables("remote_addr")%>">
	<input type="hidden" name="reg_no"  value="<%=reg_no%>">
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
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">카테고리</td>
		<td class="write_td_content">
			<select name="faq_cate" id="faq_cate" class="select" style="width:80%;">
				<%
				sql =		"select	cate_cd, cate_kind, cate_name	"
				sql = sql & "  from	web_faq_cate					"
				sql = sql & " where	isuse = '1'						"
				sql = sql & "   and	cate_kind = 'FAQ'				"
				sql = sql & " order by cate_name					"
				Set rs = DBConn.Execute(sql)
				Do While Not rs.EOF
					If faq_cate = rs("cate_cd") Then
						Response.Write "<option value=""" & rs("cate_cd") & """ selected>" & rs("cate_name") & "</option>"
					Else
						Response.Write "<option value=""" & rs("cate_cd") & """>" & rs("cate_name") & "</option>"
					End If
					rs.MoveNext
				Loop
				rs.Close	: Set rs = Nothing
				%>
			</select>
			<script>$("#faq_cate").val("<%=faq_cate%>");</script>
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">분류</td>
		<td class="write_td_content">
			<select name="faq_kind" id="faq_kind" class="select" style="width:80%;">
				<option value="FAQ">FAQ</option>
			</select>
			<script>$("#faq_kind").val("<%=faq_kind%>");</script>
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">FAQ 사용</td>
		<td class="write_td_colspan">
			<select name="isuse" id="isuse" class="select" style="width:80%;">
				<option value="1">사용</option>
				<option value="0">미사용</option>
			</select>
			<script>$("#isuse").val("<%=isuse%>");</script>
		</td>
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">FAQ 순서</td>
		<td class="write_td_colspan">
			<input type="text" name="order_view" value="<%=order_view%>" style="width:80%;" />
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">제품카테고리</td>
		<td class="write_td_colspan" colspan="3">
			<select name="pdt_cate" id="pdt_cate">
				<option value="">제품카테고리</option>
				<%
				sql =		"select	cate_cd1, cate_name				"
				sql = sql & "  from	pdt_cate1						"
				sql = sql & " where	isuse = '1'						"
				sql = sql & "   and	cate_cd1 not in ('99', '98')	"
				sql = sql & " order by cate_name					"
				Set rs = DBConn.Execute(sql)
				Do While Not rs.EOF
					If pdt_cate = rs("cate_cd1") Then
						Response.Write "<option value=""" & rs("cate_cd1") & """ selected>" & rs("cate_name") & "</option>"
					Else
						Response.Write "<option value=""" & rs("cate_cd1") & """>" & rs("cate_name") & "</option>"
					End If
					rs.MoveNext
				Loop
				rs.Close	: Set rs = Nothing
				%>
			</select>
		</td>
	</tr>
	<tr class="line_tr"><td class="line_td" colspan="4"></td></tr>

	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">FAQ 질문</td>
		<td class="write_td_colspan" colspan="3">
			<input	type="text"
					name="subject" id="subject" value="<%=subject%>"
					check="T" check_type="length" check_length="0" check_key=""
					title="글제목을 입력해 주십시오."
					class="input" style="width:500px;">
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="/bbs/img/bullet_circle.gif" align="top">FAQ 답변내용</td>
		<td class="write_td_colspan" colspan="3">

			<textarea	id="msg_body" name="msg_body"
						check="T" check_type="length" check_length="0" check_key=""
						title="글내용을 입력해 주십시오."
						style="display:none;height:100px;"><%=answer%></textarea>
		</td>
	</tr>

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
		frm.action	= "./faq_modify_ok.asp";
		frm.submit();
	}
}

function fnThisDel(){
	if (confirm("삭제 하시겠습니까?")){
		document.getElementById("btn_submit").style.display = "none";
		frm.target	="proc_fr";
		frm.action	= "./faq_del_ok.asp";
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