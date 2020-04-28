<%
'-------------------------------------------- 페이징 관련 기본 변수
PageSize = 10 '한 페이지에 출력할 레코드개수
GroupSize= 10 '페이지 목록에 나타날 페이지 개수

'-------------------------------------------- 업로드 관련 기본 변수
maxsize	 = 10 '최대허용 업로드 용량

'-------------------------------------------- 게시판 관련 기본 변수
board_id = Request("board_id")	: If board_id = "" Then Board_Id = "NOTICE"
sid		 = Request("sid")

tbl_width= "710"	'게시판 가로 폭

go_page	 = Request("page")		: If go_page = "" Then go_page = "1"
iPage	 = CInt(go_page)

'-------------------------------------------- 검색 관련 쿼리 셋팅
srch_Key	= Request("srch_key")
srch_Val	= Request("srch_val")

chk_query	= check_injection("")
If chk_query <> "OK" Then
	Response.Write "<script language='javascript'>"
	Response.Write "history.back();"
	Response.Write "</script>"
	Response.End
End If

If srch_val <> "" Then
	Select Case srch_key
	Case "name"		: srch_sql = "   and name		like '%" & srch_val	& "%'"
	Case "subject"	: srch_sql = "   and subject	like '%" & srch_val	& "%'"
	Case "content"	: srch_sql = "   and content	like '%" & srch_val & "%'"
	Case Else		: srch_sql = ""
	End Select
End If

'-------------------------------------------- 게시판 글 / 페이지 클릭시 넘겨줄 쿼리스트링
var1	= ""
var1	= var1 &		"board_id=" & board_id
var1	= var1 & "&" &	"srch_Key="	& srch_Key
var1	= var1 & "&" &	"srch_Val="	& srch_Val
var1	= var1 & "&" &	"page="		& go_page
%>