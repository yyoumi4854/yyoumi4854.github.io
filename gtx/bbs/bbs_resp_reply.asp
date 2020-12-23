<!-- #include virtual ="/common/common.inc" -->
<!-- #include virtual="/common/bbs_common.inc" -->
<%
If	session("work_user") <> "" Then
	update_user = session("work_user")
ElseIf session("admin") <> "" Then
	update_user = session("admin")
ElseIf session("userid") <> "" Then
	update_user = session("userid")
Else
	Response.Write "<script language='javascript'>"
	Response.Write "alert('정상적인 접근이 아닙니다.');"
	Response.Write "history.back();"
	Response.Write "</script>"
	Response.End
End If


bbs_kind	= Request("bbs_kind")
sid			= Request("sid")
mode		= UCase(Request("mode"))
pass_chk	= Request("pass_chk")

sql =	"Select	* from web_bbs where sid = " & sid
Set rs = DBConn.Execute(sql)

	userid		= rs("userid")
	username	= rs("username")
	bbs_cate	= rs("bbs_cate")
	target		= rs("target")
	status		= rs("status")
	isSecret	= rs("isSecret")

	passwd		= rs("passwd")
	time_limit	= rs("time_limit")
	st_date		= rs("st_date")
	ed_date		= rs("ed_date")
	If time_limit = "0" Then
		old_st_date = st_date	: old_ed_date	= ed_date
		st_date		= ""		: ed_date		= ""
	End If

	top_noti	= rs("top_noti")
	foreword	= rs("foreword")
	subject		= rs("subject")		: If foreword <> "" Then subject = "[" & foreword & "] " & subject
	content		= rs("content")

	content		= "[" & username & " 님께서 " & rs("work_date") & " 에 질문하신 내용입니다.]<br><br>" & content & "<hr><br><br>"

	email		= rs("email")
	file1_name	= rs("file1_name")
	file2_name	= rs("file2_name")
	file3_name	= rs("file3_name")
	file4_name	= rs("file4_name")
	file5_name	= rs("file5_name")

rs.Close	: Set rs = Nothing

If (session("work_user") = "") And (session("admin") = "") And (pass_chk <> passwd) Then
	Response.Write "<script language=javascript>"
	Response.Write "	alert('비밀번호가 일치하지 않습니다.\n비밀번호를 확인해 주십시오.');"
	Response.Write "	history.back();"
	Response.Write "</script>"
	Response.End
End If

If Mode = "DEL" Then
	DBConn.BeginTrans

	sql	=		"delete From web_bbs					"
	sql = sql & " where bbs_kind = '" & bbs_kind & "'	"
	sql = sql & "   and	sid = " & sid
	DBConn.Execute(sql)

	If DBConn.Errors.Count = 0 Then
		DBConn.CommitTrans
		Response.Write "<script language=javascript>"
		Response.Write "	alert('게시물이 삭제되었습니다.');"
		Response.Write "	location.href = './bbs_list.asp?" & link_str & "';"
		Response.Write "</script>"
		Response.End
	Else
		DBConn.RollBackTrans
		Response.Write "<script language=javascript>"
		Response.Write "	alert('게시물 삭제 과정에 문제가 있습니다.\n\n다시 한 번 시도해 주십시오.');"
		Response.Write "	history.back();"
		Response.Write "</script>"
		Response.End
	End If
End If
%>

<html>
<head>
	<title><%=session("company")%></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" media="all" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
	<script src="https://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
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
<link rel="stylesheet" href="./css/bbs.css" type="text/css" />

<body onLoad="resize_height();">


<table class="tbl_write_main">

	<form method="post" name="reg_frm" enctype="multipart/form-data" onsubmit="frm_chk();">
	<input type="hidden" name="go_chk">
	<input type="hidden" name="bbs_kind"	value="<%=bbs_kind%>">
	<input type="hidden" name="org_sid"		value="<%=sid%>">
	<input type="hidden" name="update_user"	value="<%=update_user%>">
	<input type="hidden" name="ip_addr"		value="<%=Request.ServerVariables("remote_addr")%>">
	<input type="hidden" name="link_query"	value="<%=link_str%>">

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
					value="<%=session("admin")%>">
		</td>
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">작성자이름</td>
		<td class="write_td_content">
			<input	type="text" class="input_read"
					name="username" id="username"
					title="작성자 이름을 입력해 주십시오."
					check="T" check_type="length" check_length="0" check_key=""
					value="<%=session("admin_name")%>">
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
			<script>document.getElementById('view_target').value = '<%=target%>';</script>
		</td>
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">상단공지</td>
		<td class="write_td_content">
			<input type="radio" name="top_noti" id="top_noti" value="0" class="input_noborder" <%If top_noti = "0" Then Response.Write "checked"%>>일반공지&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="top_noti" id="top_noti" value="1" class="input_noborder" <%If top_noti = "1" Then Response.Write "checked"%>>상단공지
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
			<script>document.getElementById('status').value = '<%=status%>';</script>
		</td>
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">게시물분류</td>
		<td class="write_td_content">
			<select	name="bbs_cate" id="bbs_cate"
					class="select"
					check="F" check_type="length" check_length="0" check_key=""
					title="게시물의 세부 분류를 지정해주십시오.">
				<option value="-" Selected>-분류-</option>
				<!--
				<option value="주문">주문</option>
				<option value="결제">결제</option>
				<option value="배송">배송</option>
				<option value="취소/환불">취소/환불</option>
				<option value="가입">가입</option>
				<option value="멤버">멤버</option>
				<option value="기타">기타</option>
				-->
			</select>
			<script>document.getElementById('bbs_cate').value = '<%=bbs_cate%>';</script>
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">게시기간</td>
		<td class="write_td_colspan" colspan="3">
			<input	type="text"
					name="st_date" id="st_date"
					style="width:80px; padding-left:2px;margin-right:2px;"
					title="항상 게시물을 보이려면 날짜를 입력하지 마십시오."
					onfocus="this.blur()"
					value="<%=st_date%>" READONLY />

			<img src="/common/img/find_fromto.gif" align="absmiddle">
			<input	type="text"
					name="ed_date" id="ed_date"
					style="width:80px; padding-left:2px;margin-right:2px;"
					title="항상 게시물을 보이려면 날짜를 입력하지 마십시오."
					value="<%=ed_date%>" READONLY />

			<span style="font-size:11px;color:#0099cc;">항상 글이 올라와있으려면 게시기간을 지정하지 마십시오.</span>
		</td>
	</tr>
	<tr class="line_tr"><td class="line_td" colspan="4"></td></tr>
	<% End If %>

	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">말머리</td>
		<td class="write_td_colspan" colspan="3">
			<input type="text" name="foreword" class="input" style="color:#000000;height:20px;background:#e0e0e0;" value="답변" readOnly onFocus="this.blur()" >&nbsp;&nbsp;
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
					class="input" style="width:500px;"
					value="<%=subject%>">
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">글내용</td>
		<td class="write_td_colspan" colspan="3">
			<!-- #include virtual="/bbs/editor/editor.html" -->
			<textarea	id="org_body" name="content"
						check="T" check_type="length" check_length="0" check_key=""
						title="글내용을 입력해 주십시오."
						style="display:none;"><%=content%></textarea>
			<input type="hidden" name="strhtml" value="2">
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title"><img src="./img/bullet_circle.gif" align="top">비밀번호</td>
		<td class="write_td_colspan" colspan="3">
			<input	type="password"
					name="passwd" id="passwd"
					title="글삭제, 수정을 위해 비밀번호를 입력해 주십시오."
					check="T" check_type="length" check_length="0" check_key=""
					value="<%=passwd%>"
					readOnly onFocus="this.blur();" style="background:#e0e0e0;">&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="hidden" name="isSecret" value="<%=isSecret%>">
			<input type="checkbox" name="old_isSecret" value="1" class="input_noborder" <%If isSecret = "1" Then Response.Write "checked"%> disabled>비밀글
		</td>
	</tr>
	<tr class="write_tr">
		<td class="write_td_title" valign="top"><img src="./img/bullet_circle.gif" align="top">첨부파일</td>
		<td class="write_td_colspan" colspan="3">
			<span style="height:21px;width:80px; background:#b7badb;padding:3 0 0 0px;font-size:12px;text-align:center;color:#000000;vertical-align:middle;">현재첨부파일</span>
			<span style="height:21px;width:274px;background:#C4CECC;padding:3 0 0 2px;font-size:12px;color:#000000;vertical-align:middle;"><%=file1_name%></span>
			&nbsp;
			<input	type="checkbox"
					name="file1_del" id="file1_del" value="1"
					class="input_noborder" style="vertical-align:middle;"
					onFocus="this.blur()"/>
			<input	type="button"
					style="width:35px;height:21px;background:#FF0000;color:#FFFFFF;text-align:center;font-size:12px;padding:0px;vertical-align:middle;"
					value="삭제" onFocus="this.blur()"
					onClick="javascript:if(!document.getElementById('file1_del').checked){document.getElementById('file1_del').checked=true;}else{document.getElementById('file1_del').checked=false;}"/><br>
			<input type="hidden" name="old_upfile" value="<%=file1_name%>">
			<input type="file" name="upfile" style="width:456px;">
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
<script language="javascript">
var frm = document.reg_frm;

function frm_chk() {

	var proc_ok = "T";

	var szContent = getOrgSource();
	document.getElementById('org_body').value=szContent;

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
		frm.action	= "./bbs_reply_ok.asp";
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