<%
bbs_kind	= Request("bbs_kind")	: If bbs_kind = "" Then bbs_kind = "NOTICE"
sid			= Request("sid")

sql = "select write_level, bbs_name, bbs_type from web_bbs_cate where bbs_kind = '" & bbs_kind & "'"

Set rs_bbs = DBConn.Execute(sql)
	write_level	= rs_bbs("write_level")
	bbs_name	= rs_bbs("bbs_name")
	bbs_type	= rs_bbs("bbs_type")
rs_bbs.Close : Set rs_bbs = Nothing

'────────────────────────────────────────
'업로드 관련 기본 변수
'────────────────────────────────────────
up_limit	= 20			'최대 허용 업로드 용량 (MByte)
maxsize		= up_limit * 1024 * 1024	'최대 허용 업로드 용량 (Byte)
LimitWidth	= 1024						'최대 업로드 이미지의 가로 크기 (1024px)

'────────────────────────────────────────
'페이징 처리 관련 기본 변수
'────────────────────────────────────────
PageSize	= 10						'한 페이지에 출력할 레코드개수
If bbs_type = "G" Then PageSize = 8
GroupSize	= 5						'페이지 목록에 나타날 페이지 개수
go_page		= Request("go_page")		: If go_page = "" Then go_page = "1"
go_page		= CInt(go_page)


'────────────────────────────────────────
'게시판 디자인 관련 기본 변수
'────────────────────────────────────────
bbs_width	= "1000"						'게시판 가로 폭
cell_height	= "25"


'────────────────────────────────────────
'검색 관련 쿼리 셋팅
'────────────────────────────────────────
srch_Key	= Request("srch_key")
srch_Val	= Request("srch_val")

If srch_val <> "" Then
	Select Case srch_key
	Case "name"		: srch_sql = "   and username	like '%" & srch_val	& "%'"
	Case "subject"	: srch_sql = "   and subject	like '%" & srch_val	& "%'"
	Case "content"	: srch_sql = "   and content	like '%" & srch_val & "%'"
	Case "all"		: srch_sql = "   and ( content	like '%" & srch_val & "%' Or subject	like '%" & srch_val & "%') "
	Case Else		: srch_sql = ""
	End Select
End If

'────────────────────────────────────────
'게시판 링크 클릭시 기본 인자 설정
'────────────────────────────────────────
link_str= ""
link_str= link_str &		"bbs_kind=" & bbs_kind
link_str= link_str & "&" &	"srch_Key="	& srch_Key
link_str= link_str & "&" &	"srch_Val="	& srch_Val
link_str= link_str & "&" &	"go_page="	& go_page

tableWidth="950"
colCount="4"

Function  typeTableWidh(bType,defaultTableWidth)
	strTableWidh = ""
	If bType = "G" Then
		defaultTableWidth="800"
		strTableWidh =				  "	<colgroup>						"
		strTableWidh = strTableWidh & "	<col width="&defaultTableWidth&" />	"
		strTableWidh = strTableWidh & "	</colgroup>						"
	ElseIf bType = "G" Then
		defaultTableWidth="950"
		strTableWidh =				  "	<colgroup>						"
		strTableWidh = strTableWidh & "	<col width="&defaultTableWidth&" />	"
		strTableWidh = strTableWidh & "	</colgroup>						"
	Else
		'기본형
		strTableWidh =				  "	<colgroup>						"
		strTableWidh = strTableWidh & "	<col width="&defaultTableWidth&" />	"
		strTableWidh = strTableWidh & "	</colgroup>						"

	End If
	typeTableWidh = strTableWidh

End Function

Function typeWriteTable(bType)
	strWriteTable = ""
	If bType = "G" Then

		strWriteTable =				  "	<colgroup>						"
		strWriteTable = strWriteTable & "		<col width='100' />			"
		strWriteTable = strWriteTable & "		<col width='260' />			"
		strWriteTable = strWriteTable & "		<col width='100' />			"
		strWriteTable = strWriteTable & "		<col width='260' />			"
		strWriteTable = strWriteTable & "	</colgroup>						"
	ElseIf bType = "P" Then


		strWriteTable =				  "	<colgroup>						"
		strWriteTable = strWriteTable & "		<col width='175' />			"
		strWriteTable = strWriteTable & "		<col width='275' />			"
		strWriteTable = strWriteTable & "		<col width='275' />			"
		strWriteTable = strWriteTable & "		<col width='325' />			"
		strWriteTable = strWriteTable & "	</colgroup>						"
	Else
		'기본형
		strWriteTable =				  "	<colgroup>						"
		strWriteTable = strWriteTable & "		<col width='100' />			"
		strWriteTable = strWriteTable & "		<col width='260' />			"
		strWriteTable = strWriteTable & "		<col width='100' />			"
		strWriteTable = strWriteTable & "		<col width='260' />			"
		strWriteTable = strWriteTable & "	</colgroup>						"

	End If
	typeWriteTable = strWriteTable
End Function

%>
<script language="javascript">

</script>
<div id="scr_dimmer" style="background:#e9e9e9;"></div>