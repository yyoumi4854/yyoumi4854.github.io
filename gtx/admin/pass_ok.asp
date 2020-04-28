<%@ CodePage="65001" Language="vbscript"%>

<!-- #include virtual="/myoffice/common/db_connect.inc" -->
<%
ADMIN_CODE	= REQUEST.FORM("ADMIN_CODE")
PASSWORD1	= REQUEST.FORM("PASSWORD1")
PASSWORD2	= REQUEST.FORM("PASSWORD2")

INJECTION_FILTER  = "script|/script|or |and |union|delete|select|update |drop table|drop column|alter table|alter column|create |insert|;--|declare|exec|set @"
STR_TYPE = PASSWORD1 & "," & PASSWORD2

STR_TYPE = SPLIT(STR_TYPE,",")
INJ_FILTER		= SPLIT(INJECTION_FILTER,"|")
INJ_FILTER_CNT	= UBOUND(INJ_FILTER)
	FOR J=0 TO UBOUND(STR_TYPE)
		FOR I=0 TO INJ_FILTER_CNT

			IF INSTR(1,STR_TYPE(J),INJ_FILTER(I),1) > 0 THEN
			RESPONSE.WRITE "<script language='javascript'>"
			RESPONSE.WRITE "	alert('특수문자나 명령어로는 비밀번호를 변경할 수 없습니다.');"
			RESPONSE.WRITE "	history.back();"
			RESPONSE.WRITE "</script>"
			RESPONSE.END
		END IF
		NEXT
	NEXT

If PASSWORD1 <> PASSWORD2 Then
%>
	<script language="javascript">
		alert("비밀번호가 일치하지 않습니다.\n\n확인후 다시 시도해 주십시오");
		history.back();
	</script>
<%
Else
	sql = "update WEB_ADMIN set passwd = '" & password1 & "' "
	sql = sql & " where userid = '" & admin_code & "' "

	dbconn.execute sql

%>
	<script language="javascript">
		alert("비밀번호가 변경되었습니다.");
		//parent.location.replace('/admin/admin.asp?board_id=admin')
		  parent.location.replace('/admin/admin_frame.asp?board_id=NOTICE')
	</script>
<%
End if
%>