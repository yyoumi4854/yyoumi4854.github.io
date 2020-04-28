<!-- #include virtual ="/myoffice/common/common.inc" -->
<html>
<head>
	<title><%=session("company")%></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>

	<link rel="stylesheet" href="https://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" media="all" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
	<script src="https://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="/bbs/NEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	<script>
	$(document).ready(function() {
		resize_height();
		$("#st_date, #ed_date").datepicker({
		    //"" or "button" 입력필드 옆에 아래 지정한 아이콘 표시	showOn: "",
			buttonImage: "/myoffice/common/img/find_btn_cal.gif",
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
<link rel="stylesheet" href="./css/bbs.css" type="text/css" />

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
<!-- #include virtual="/myoffice/common/bbs_common.inc" -->

<body  >

<table class="tbl_write">
	<form method="post" name="reg_frm" enctype="multipart/form-data" onsubmit="frm_chk();">

	<input type="hidden" name="go_chk">
	<input type="hidden" name="bbs_kind" value="<%=bbs_kind%>">
	<input type="hidden" name="ip_addr"  value="<%=Request.ServerVariables("remote_addr")%>">

	<colgroup>
		<col width="100" />
		<col width="360" />
		<col width="100" />
		<col width="360" />
	</colgroup>

	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">작성자ID</td>
		<td class="write_td_content">
			<input	type="text" class="input_read"
					name="userid" id="userid"
					check="T" check_type="length" check_length="0" check_key=""
					title="작성자ID를 입력해 주십시오."
					value="<%=userid%>">
		</td>
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">작성자이름</td>
		<td class="write_td_content">
			<input	type="text" class="<%=class_name%>"
					name="username" id="username"
					title="작성자 이름을 입력해 주십시오."
					check="T" check_type="length" check_length="0" check_key=""
					value="<%=username%>">
		</td>
	</tr>

	<% If write_level = "ADMIN" And session("admin") <> "" Then %>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">공지유형</td>
		<td class="write_td_content">
			<select	name="view_target" id="view_target"
					class="select">
				<option value="0" Selected>전체</option>
				<option value="1">로그인회원</option>
			</select>
		</td>
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">상단공지</td>
		<td class="write_td_content">
			<!--
			<input type="radio" name="top_noti" id="top_noti" value="0" class="input_noborder" checked> 일반공지&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="top_noti" id="top_noti" value="1" class="input_noborder"> 상단공지
			-->
			<select	name="top_noti" id="top_noti" class="select">
				<option value="0">일반게시</option>
				<option value="1">상단게시</option>
				<% If bbs_kind = "NOTICE" Then%>
				<option value="3">메인좌상단</option>
				<option value="4">메인우상단</option>
				<% End If%>
			</select>
		</td>
	</tr>

	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">글상태</td>
		<td class="write_td_content">
			<select name="status" id="status"
					class="select">
				<option value="0">게시보류</option>
				<option value="1" Selected>정상게시</option>
				<option value="2">게시종료</option>
			</select>
		</td>
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">게시물분류</td>
		<td class="write_td_content">
			<select	name="bbs_cate" id="bbs_cate"
					class="select"
					check="F" check_type="length" check_length="0" check_key=""
					title="게시물의 세부 분류를 지정해주십시오.">
				<%
				IF bbs_kind = "NOTICE" Then
				%>
				<option value="공지사항">공지사항</option>
				<option value="프로모션">프로모션</option>
				<option value="이벤트">이벤트</option>
				<%
				ElseIf bbs_kind = "PDS" Then
				%>
				<option value="서식자료">서식자료</option>
				<option value="교육자료">교육자료</option>
				<option value="영상자료">영상자료</option>
				<%
				End If
				%>
			</select>
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">게시기간</td>
		<td class="write_td_colspan" colspan="3">
			<input	type="text"
					name="st_date" id="st_date"
					title="항상 게시물을 보이려면 날짜를 입력하지 마십시오."
					style="width:80px; padding-left:2px;margin-right:2px;"
					value="<%=st_date%>" READONLY />

			<img src="/myoffice/common/img/find_fromto.gif" align="absmiddle">
			<input	type="text"
					name="ed_date" id="ed_date"
					title="항상 게시물을 보이려면 날짜를 입력하지 마십시오."
					style="width:80px; padding-left:2px;margin-right:2px;"
					value="<%=ed_date%>" READONLY />

			<span style="font-size:11px;color:#0099cc;">항상 글이 올라와있으려면 게시기간을 지정하지 마십시오.</span>
		</td>
	</tr>
	<tr class="line_tr"><td class="line_td" colspan="4"></td></tr>
	<% End If %>

	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">말머리</td>
		<td class="write_td_colspan" colspan="3">
			<input type="text" name="foreword" value="" class="input" style="color:#000000;height:20px;">&nbsp;&nbsp;
			<span style="font-size:11px;color:#0099cc;">말머리는 게시물 제목에 "<span style="color:#0000cc;font-weight:bold;">[말머리]</span>" 와 같이 표시됩니다.</span>
		</td>
	</tr>

	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">글제목</td>
		<td class="write_td_colspan" colspan="3">
			<input	type="text"
					name="subject" id="subjecct"
					check="T" check_type="length" check_length="0" check_key=""
					title="글제목을 입력해 주십시오."
					class="input" style="width:500px;">
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">글내용</td>
		<td class="write_td_colspan" colspan="3">

			<textarea	id="msg_body" name="msg_body"
						check="T" check_type="length" check_length="0" check_key=""
						title="글내용을 입력해 주십시오."
						style="display:none;height:100px;width:100%;min-width:260px;"><%=contents%></textarea>
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">비밀번호</td>
		<td class="write_td_colspan" colspan="3">
			<input	type="password"
					name="passwd" id="passwd"
					title="글삭제, 수정을 위해 비밀번호를 입력해 주십시오."
					check="T" check_type="length" check_length="0" check_key="">&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="isSecret" value="1" style="border:none;"> 비밀글
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top"><%If bbs_Type = "G" Then
		%>이미지파일<%
		Else
			%>첨부파일<%
		End If
		%>
		</td>
		<td class="write_td_colspan" colspan="3">
			<input type="file" name="upfile" style="width:400px;">
		</td>
	</tr>
	<tr class="submit_tr">
		<td colspan="4" class="submit_td">
			<div id="btn_submit" style="diplay:inline;">
			<img src="./img/btn_complete.gif"	style="cursor:pointer;" onClick="frm_chk();">&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="./img/btn_cancel.gif"		style="cursor:pointer;" onClick="javascript:history.back();">
			</div>
		</td>
	</tr>

	</form>
</table>


<iframe name="proc_fr" id="proc_fr" style="width:600px;height:200px;display:none;"></iframe>
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
		//document.getElementById("btn_submit").style.display = "none";
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

</html>