<%@ CodePage="65001" Language="vbscript"%>
<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual="/board/bbs_common.inc" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" rel="stylesheet" type="text/css">
</head>
<%
On Error Resume Next

mode	= Request("mode")
reg_no	= Request("reg_no")
page	= Request("page")

If reg_no = "" Then

	response.write "<script language=javascript>"
	response.write "alert('잘못된 접근입니다.');"
	response.write "history.back();"
	response.write "</script>"
	response.End
ElseIf mode = "DEL" Then

	DBConn.BeginTrans

	sql =		"delete from web_schedule	"
	sql = sql & " where	reg_no = " & reg_no
	DBConn.Execute(sql)

	If Err.Number = 0 Then
		DBConn.CommitTrans
		response.write "<script language=javascript>"
		response.write "alert('일정이 삭제되었습니다.');"
		response.write "location.href = './schedule_list.asp?page=" & page & "';"
		response.write "</script>"
		response.End
	Else
		DBConn.RollBackTrans
		response.write "<script language=javascript>"
		response.write "alert('일정삭제 과정에 문제가 있습니다.\n잠시 후 다시 시도해 주십시오.');"
		response.write "history.back();"
		response.write "</script>"
		response.End
	End If

ElseIf mode = "EDIT" Then

	sql =		" select *						"
	sql = sql & "   from web_schedule			"
	sql = sql & "  where reg_no = " & reg_no
	Set rs = DBconn.execute(sql)

	If rs("repeat_yn") = "1" Then
		re_start_yy = Left(rs("repeat_start"),4)
		re_start_mm = Right(rs("repeat_start"),2)
		re_end_yy	= Left(rs("repeat_end"),4)
		re_end_mm	= Right(rs("repeat_end"),2)
	End If
%>
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

	<body>
	<% If session("admin") <> "" Then response.write "<br>" %>
	<form method="post" action="schedule_edit_ok.asp" name="form" onSubmit="return send();" enctype="multipart/form-data">
	<input type="hidden" name="work_user"	value="<%=Session("Login_ID")%>">
	<input type="hidden" name="name"		value="<%=session("memb_name")%>">
	<input type="hidden" name="reg_no"		value="<%=reg_no%>">
	<input type="hidden" name="page"		value="<%=page%>">

	<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="border-top:2px solid #ffa4be; border-bottom:2px solid #dddddd" align="center">
		<tr>
			<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정제목</td>
			<td align="left" class="paddingL10">
				<input type="text" NAME="subject" size="70" class="textbox01" value="<%=rs("subject")%>">
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
					<option value="<%=i%>" <% If i=CInt(rs("years")) Then response.write "selected" %>><%=i%></option>
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
					<option value="<%=i%>" <% If i=CInt(rs("moth")) Then response.write "selected" %>><%=i%></option>
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
					<option value="<%=i%>" <% If i=CInt(rs("days")) Then response.write "selected" %>><%=i%></option>
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
				<input type="radio" NAME="view_web" value="1" <% If rs("view_web") = "1" Then response.write "checked" %>>표시함
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" NAME="view_web" value="0" <% If rs("view_web") = "0" Then response.write "checked" %>>표시안함
			</td>
		</tr>
		<tr>
			<td height="1" colspan="2" class="line"></td>
		</tr>
		<tr>
			<td width="70" height="30" align="center" style="font-size:12px;font-weight:bold;border-right:1px solid #dddddd;">일정반복</td>
			<td align="left" class="paddingL10">
				<input type="radio" NAME="repeat_yn" value="1" onClick="repeat_set();" <% If rs("repeat_yn") = "1" Then response.write "checked" %>>매월반복
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" NAME="repeat_yn" value="0" onClick="repeat_set();" <% If rs("repeat_yn") = "0" Then response.write "checked" %>>반복안함
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
						setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc" <% If rs("repeat_yn") = "0" Then response.write "disabled" %>>
					<option value="--">-연도-</option>
				<% For i=CInt(Year(date))-1 To CInt(Year(Date))+1 %>
					<option value="<%=i%>" <% If i=CInt(re_start_yy) Then response.write "selected" %>><%=i%></option>
				<% Next %>
				</select>
				<input type="text" value="년" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
				<select name="re_start_mm"
						class="select"
						style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
						setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc"  <% If rs("repeat_yn") = "0" Then response.write "disabled" %>>
					<option value="--">-월-</option>
				<% For i=1 To 12 %>
					<option value="<%=i%>" <% If i=CInt(re_start_mm) Then response.write "selected" %>><%=i%></option>
				<% Next %>
				</select>
				<input type="text" value="월" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
				&nbsp;&nbsp;
				<input type="text" value="~" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
				&nbsp;&nbsp;
				<select name="re_end_yy"
						class="select"
						style="width:60px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
						setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc"  <% If rs("repeat_yn") = "0" Then response.write "disabled" %>>
					<option value="--">-연도-</option>
				<% For i=CInt(Year(date))-1 To CInt(Year(Date))+10 %>
					<option value="<%=i%>" <% If i=CInt(re_end_yy) Then response.write "selected" %>><%=i%></option>
				<% Next %>
				</select>
				<input type="text" value="년" style="width:15px;height:20px;padding-top:3px;border:0px;font-size:12px;" readOnly onFocus="this.blur()">
				<select name="re_end_mm"
						class="select"
						style="width:50px; height:20px; border:0px; behavior:url('/css/selectBox.htc');"
						setimage="/img/share/arrow_image.gif" setcolor="#666666,#ffffff,#666666,#e1e1e1,#cccccc,#cccccc"  <% If rs("repeat_yn") = "0" Then response.write "disabled" %>>
					<option value="--">-월-</option>
				<% For i=1 To 12 %>
					<option value="<%=i%>" <% If i=CInt(re_end_mm) Then response.write "selected" %>><%=i%></option>
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
				<textarea name="Content" class="textbox01" id="content" style="width:500px;height:100px;"><%=rs("content")%></textarea>
			</td>
		</tr>
	</table>
	<table width="<%=tbl_width%>" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px" align="center">
		<tr>
			<td width="70" height="30" align="left"><a href="./schedule_list.asp?page=<%=page%>"><img src="img/btn_list3.gif"></a></td>
			<td align="right" class="paddingL10">
				<input type="image" src="img/btn_submit.gif">&nbsp;
				<img src="img/btn_cancel.gif" onClick="javascript:history.back();">
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


<% End If %>