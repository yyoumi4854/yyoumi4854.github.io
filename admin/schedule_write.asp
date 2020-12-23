<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/admin/schedule_common.inc" -->
<% board_id = "SCHEDULE" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" rel="stylesheet" type="text/css">
</head>
<script language="javascript">
function send() {
	if (document.form.subject.value == "") {
		alert("일정제목을 입력하세요.");
		document.form.subject.focus();
		return false;
	}
	if(document.form.sch_yy.value == "--") {
		alert("일정일자 연도를 입력하세요.");
		document.form.sch_yy.focus();
		return false;
	}
	if(document.form.sch_mm.value == "--") {
		alert("일정일자 월을 입력하세요.");
		document.form.sch_mm.focus();
		return false;
	}
	if(document.form.sch_dd.value == "--") {
		alert("일정일자 일을 입력하세요.");
		document.form.sch_dd.focus();
		return false;
	}
	if (document.form.Content.value == "") {
		alert("상세일정이 없습니다.\n\n확인 후 다시 입력해 주십시오.");
		return false;
	}
return true;
}
</script>
<body onLoad="resize_height();">
<% If Session("admin") <> "" Then response.write "<br>" %>
<form method="post" action="schedule_write_ok.asp" name="form" onSubmit="return send();" enctype="multipart/form-data">
<input type="hidden" name="work_user"	value="<%=Session("Login_ID")%>">
<input type="hidden" name="name"		value="<%=session("memb_name")%>">
<input type="hidden" name="board_id"	value="<%=board_id%>">

<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="border-top:2px solid #ffa4be; border-bottom:2px solid #dddddd" align="center">
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정제목</td>
		<td align="left" class="paddingL10">
			<input type="text" NAME="subject" size="70" class="textbox01">
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정일자</td>
		<td align="left" class="paddingL10">
			<select name="sch_yy"
					class="select"
					style="width:60px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="--">-연도-</option>
			<% For i=CInt(Year(date))-1 To CInt(Year(Date))+1 %>
				<option value="<%=i%>" <% If i=CInt(Year(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="년" style="width:20px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			&nbsp;&nbsp;
			<select name="sch_mm"
					class="select"
					style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="--">-월-</option>
			<% For i=1 To 12 %>
				<option value="<%=i%>" <% If i=CInt(Month(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="월" style="width:20px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			&nbsp;&nbsp;
			<select name="sch_dd"
					class="select"
					style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc">
				<option value="--">-일-</option>
			<% For i=1 To 31 %>
				<option value="<%=i%>" <% If i=CInt(Day(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
			<input type="text" value="일" style="width:20px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			</select>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">표시여부</td>
		<td align="left" class="paddingL10">
			<input type="radio" NAME="view_web" value="1" checked>표시함
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" NAME="view_web" value="0">표시안함
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정반복</td>
		<td align="left" class="paddingL10">
			<input type="radio" NAME="repeat_yn" value="1" onClick="repeat_set();">매월반복
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" NAME="repeat_yn" value="0" checked onClick="repeat_set();">반복안함
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">반복기간</td>
		<td align="left" class="paddingL10">
			<select name="re_start_yy"
					class="select"
					style="width:60px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc" disabled>
				<option value="--">-연도-</option>
			<% For i=CInt(Year(date))-1 To CInt(Year(Date))+1 %>
				<option value="<%=i%>" <% If i=CInt(Year(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="년" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			<select name="re_start_mm"
					class="select"
					style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc" disabled>
				<option value="--">-월-</option>
			<% For i=1 To 12 %>
				<option value="<%=i%>" <% If i=CInt(Month(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="월" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			&nbsp;&nbsp;
			<input type="text" value="~" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			&nbsp;&nbsp;
			<select name="re_end_yy"
					class="select"
					style="width:60px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc" disabled>
				<option value="--">-연도-</option>
			<% For i=CInt(Year(date))-1 To CInt(Year(Date))+10 %>
				<option value="<%=i%>" <% If i=CInt(Year(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="년" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			<select name="re_end_mm"
					class="select"
					style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
					setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc" disabled>
				<option value="--">-월-</option>
			<% For i=1 To 12 %>
				<option value="<%=i%>" <% If i=CInt(Month(date)) Then response.write "selected" %>><%=i%></option>
			<% Next %>
	        </select>
			<input type="text" value="월" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
			&nbsp;&nbsp;
		</td>
	</tr>
	<tr>
		<td height="1" colspan="2" class="line"></td>
	</tr>
	<tr>
		<td width="70" height="33" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">상세일정</td>
		<td align="left" class="paddingL10" style="padding-top:10px;padding-bottom:10px;">
			<textarea name="Content" class="textbox01" id="content" style="width:500px;height:100px;"></textarea>
		</td>
	</tr>
</table>
<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px" align="center">
	<tr>
		<td width="70" height="30" align="left"><a href="./schedule_list.asp"><img src="img/btn_list3.gif" border="0"></a></td>
		<td align="right" class="paddingL10">
			<input type="image" src="img/btn_submit.gif">&nbsp;
			<img src="img/btn_cancel.gif" onClick="location.href='./schedule_list.asp';">
		</td>
	</tr>
</table>
</form>
</body>
</html>
<script language=javascript>
function resize_height()
{
	var h_size = document.body.scrollHeight;
	if (h_size < 500) { h_size = 500; }

	if(parent.document.getElementById("bbs_iframe")) {
		parent.document.getElementById("bbs_iframe").height = h_size;
	}
}

function repeat_set()
{
	var frm = document.form;

	if(frm.repeat_yn[0].checked) {
		frm.re_start_yy.disabled	= false;
		frm.re_start_mm.disabled	= false;
		frm.re_end_yy.disabled		= false;
		frm.re_end_mm.disabled		= false;
	} else {
		frm.re_start_yy.disabled	= true;
		frm.re_start_mm.disabled	= true;
		frm.re_end_yy.disabled		= true;
		frm.re_end_mm.disabled		= true;
	}
}
</script>