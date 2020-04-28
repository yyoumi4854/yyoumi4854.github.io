<!-- #include virtual="/myoffice/common/db_connect.inc" -->


<link href="/board/css/style.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JAVASCRIPT">
	function sendit(){
		if (document.FORM.PASSWORD1.value == "") {
		alert("새 비밀번호를 입력하세요.\n");
		document.FORM.PASSWORD1.focus();
		return false;
		}
	if (document.FORM.PASSWORD2.value == "") {
		alert("새 비밀번호를 입력하세요.\n");
		document.FORM.PASSWORD2.value == ""();
		return false;
		}
	document.FORM.action="pass_ok.asp";
	document.FORM.submit();
	}
function checkkeycode(t){
  if((t.keyCode > 32 && t.keyCode < 48) || (t.keyCode > 57 && t.keyCode < 65)||(t.keyCode > 90 && t.keyCode < 97))
  {
   t.returnValue = false;
   alert("특수문자나 공백은 입력하실 수 없습니다.");
 //  document.login_frm.MEMB_ID.focus();
  }
 }

</SCRIPT>
<%
		SET RS = SERVER.CREATEOBJECT("ADODB.RECORDSET")
		SQL =		"SELECT	USERID "
		SQL = SQL & "  FROM WEB_ADMIN"
		SQL = SQL & "  WHERE USERID = '"&SESSION("ADMIN")&"' "
		RS.OPEN SQL, DBConn

%>
<link href="./css/admin_style.css" rel="stylesheet"  type="text/css">
<BODY OnLoad="javascript:document.FORM.PASSWORD1.focus();">
<FORM METHOD="post" NAME="FORM" Onsubmit="return sendit();" >
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<TR><TD HEIGHT="15"></TD></TR>
  <tr>
    <td align="center" valign="middle"><table width="300" border="0" cellspacing="0" cellpadding="0">
       <tr>
        <td height="2" bgcolor="#E6E6E6" ></td>
      </tr>
      <tr>
        <td height="29" align="center" bgcolor="#F5F5F5" class="text"  ><strong>비밀번호 변경 </strong></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#EAEAEA"></td>
      </tr>

      <tr>
        <td height="120" align="center" valign="middle" bgcolor="#FFFFFF">
          <table width="96%" border="0" cellpadding="0" cellspacing="10" class="text">
          <tr>
            <td align="LEFT">사용자 아이디 &nbsp;&nbsp;&nbsp;&nbsp;: <%=RS("USERID")%>
              <INPUT TYPE="HIDDEN" NAME="ADMIN_CODE" VALUE="<%=RS("USERID")%>">
              </td>
          </tr>

          <tr>
            <td align="LEFT">새 비밀번호 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:

              <input name="PASSWORD1" TYPE="PASSWORD" class="textbox" size="15">
              </td>
          </tr>
          <tr>
            <td align="LEFT">새 비밀번호 확인 :

              <input name="PASSWORD2" TYPE="PASSWORD" class="textbox" size="15">
              </td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="1"  bgcolor="#EAEAEA"></tr>
      <tr>
        <td height="30"  align="center" ><input type="image" src="/admin/img/but_login.gif" width="50" height="22" border="0" style='cursor:hand;'></td>
      </tr>
    </table></td>
  </tr>
</table>
</FORM>
</BODY>