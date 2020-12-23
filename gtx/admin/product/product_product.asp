<!-- #include virtual="/myoffice/common/db_connect.inc" -->
<!--#include virtual="/myoffice/common/function.inc"-->
<%
srch_Key = request("srch_Key")
srch_Val = LCase(request("srch_Val"))
%>
<link rel="stylesheet" href="/myoffice/css/basic.css">
<link rel="stylesheet" href="/myoffice/css/admin.css">
<style type="text/css">
	td, th, table, body, textarea, select, input, dt, dd {
		font-size: 12px;
		font-family:"나눔고딕", NanumGothic;
	}
</style>

<body>
	<div id="wrap">

		<div id="admin_con_area">

			<div class="admin_contents">
				<!---- 콘텐츠 현재 위치 ----->

				<!--###################### 내용 #########################-->
				<h3 class="admin_title">상품 목록</h3>
				<div class="a_mem_searchbox" style="width:800px;">
				<form id="frm_search" name="frm_search" action="<%=Request.ServerVariables("URL")%>"  >
					검색조건
					<select name="srch_Key" id="srch_Key" style="width:110px;">
						<option value="title" <%If srch_Key = "title" Then Response.WRite "Selected" End If %>>판매명</option>
					</select>
					<input type="text"name="srch_Val" id="srch_Val" value="<%=srch_Val%>" style="width:160px;color:#555;" />
					<img src="../img/btn_search.gif" style="vertical-align:middle;" alt=" 검색" onclick="frm_search.submit();" />
				</div>
				</form>
				<div class="mem_list_area" style="width:800px;">

				<%
						go_page	= request("go_page")
						GroupSize="10"
						PageSize="10"
						If go_page = "" Then go_page="1" End If
						If PageSize = "" Then PageSize="10" End If

						If srch_Key="title" And srch_Val<>"" Then
							searchSql = searchSql & "and ( lower(a.product_name) like '%"&srch_Val&"%' or lower(a.model_name) like '%"&srch_Val&"%' ) "

						End If

						Set rs = Server.CreateObject("ADODB.RecordSet")
						rs.cursortype = 3
						sql =		"select a.product_cd,	a.product_name,	a.model_name,			"
						sql = sql & "		c.webinfo_cd,	c.img_thumnail,	c.WEBINFO_NAME,	c.img_s,"
						sql = sql & "		c.img_m,	c.img_l,	c.work_date,	c.ISUSE,		"
						sql = sql & "		a.isWeb  From product a,pdt_webinfo c					"
						sql = sql & " where	c.product_cd = a.product_cd(+)							"

						sql = sql &searchSql

						sql = sql & "order by WEBINFO_CD desc  "

						'Response.WRite sql
						rs.Open sql, DBConn
						If (rs.Bof and rs.Eof) Then
							TotRecord = 0
							TotPage   = 0
						Else

							TotRecord	= rs.RecordCount
							rs.PageSize = PageSize			'한페이지에 보여줄 레코드개수
							TotPage		= rs.PageCount

						End If
				%>
					<p class="txt_r">전체 : <%=TotRecord%></p>
					<form name="reg_frm" id="reg_frm" method="post"  enctype="multipart/form-data" >
					<table border="0" cellpadding="0" cellspacing="0" class="a_mem_tb" style="width:100%;">
						<colgroup>
							<col style="width:30px;">
							<col style="width:50px;">
							<col style="width:250px;">
							<col style="width:50px;">
							<col style="width:50px;">
							<col style="width:50px;">
							<col style="width:50px;">
							<col style="width:80px;">
							<col style="width:auto;">
						</colgroup>
						<tr>
							<th><input type="checkbox" name="sel_all" id="sel_all" onclick="all_sel();" /></th>
							<th>번호</th>
							<th>판매명</th>
							<th>썸네일</th>
							<th>작은이미지</th>
							<th>중간이미지</th>
							<th>큰이미지</th>
							<th>게시여부</th>
							<th>등록일</th>

						</tr>
						<%


						If Not  (rs.Bof and rs.Eof) Then

						rs.AbsolutePage = go_page								'해당 페이지의 첫번째 레코드로 이동한다
						Rcount			= rs.PageSize
						tempNo			= TotRecord-(go_page-1)*(Rcount)		'레코드번호로 사용할 임시번호
						cnt = 1
						Do While (Not rs.eof) And (Rcount > 0 )
							productshop_cd		= rs("PRODUCT_CD")
							productshop_name	= rs("PRODUCT_NAME")
							sid					= rs("WEBINFO_CD")
							webinfo_name		= rs("WEBINFO_NAME")
							img_thumnail		= rs("IMG_THUMNAIL")
							img_s				= rs("IMG_S")
							img_M				= rs("IMG_M")
							img_L				= rs("IMG_L")
							work_date			= rs("WORK_DATE")
							'isuse				= rs("ISUSE") : If isuse="0" Then struse ="보류" Else struse ="게시" End If
							isWeb				= rs("isWeb") : If isWeb = "0" Then struse ="<span style=""color:red"">보류</span>" Else struse ="게시" End If
							model_name			= rs("model_name")




							'img_ss		= rs("IMG_SS")
							'option_desc		= rs("option_desc")

						%>
						<tr>
							<td><input type="checkbox" name="sid" id="sid" value="<%=sid%>" /></td>
							<td><%=cnt%></td>
							<td>
								<p><span>[<%=productshop_cd%>]</span><%=webinfo_name%></p>
								<p><a href="./product_product_edit.asp?sid=<%=sid%>"><span><%=productshop_name%></span></a></p>
								<p><span><%=model_name%></span></a></p>
							</td>
							<td class="pro_td">
								<p class="small_img" style=""><img src="<%=img_thumnail%>" style="width:50px;height:50px;" /></p>
							</td>
							<td class="pro_td">
								<p class="small_img"><img src="<%=img_s%>" style="width:50px;height:50px;" /></p>
							</td>
							<td class="pro_td">
								<p class="small_img"><img src="<%=img_m%>" style="width:50px;height:50px;" /></p>
							</td>
							<td class="pro_td">
								<p class="small_img"><img src="<%=img_L%>" style="width:50px;height:50px;" /></p>
							</td>
							<td><%=struse%></td>
							<td><%=work_date%></td>
						</tr>
						<%
						cnt=cnt+1
						Rcount	= Rcount - 1
						rs.movenext
						Loop
						rs.Close : Set rs = Nothing
						end If
						%>

					</table>
					</form>

							<%
							'페이징 처리
							page_str= Request.ServerVariables("URL")
							page_str= page_str & "?" &	"srch_Key="	& srch_Key
							page_str= page_str & "&" &	"srch_Val="	& srch_Val
							'테스트
							'Call getPager(100,5,go_page,10,page_str)
							Call getPager(TotPage,colCount,go_page,groupsize,page_str)
							%>
					<div style="float:right;padding-top:20px;" >
						<a href="./product_product_write.asp"><img src="../img/btn_save.gif" /> </a> <a href="#" onclick="go_del();"><img src="../img/btn_delete.gif" /> </a>
					</div>
				</div>

				<iframe id="proc_fr" name="proc_fr" width="100%" height="300px" style="display:none;"></iframe>




			<!--###################### 내용 #########################-->
			</div>
		</div>
		<!--------------------------------- 푸터 --------------------------->

	</div>
<Script>

	var frm  = document.reg_frm;
function go_del() {

	if (confirm('삭제 하시겠습니까?'))
	{
		frm.target	="proc_fr";
		frm.action	= "./product_product_del_ok.asp";
		frm.submit();
	}

}
function all_sel() {
	var	listCnt	=0;
	if (typeof frm.sid.length =='undefined'){
		listCnt	=1;
	}else{
		listCnt = frm.sid.length - 1;
	}
	if (listCnt >= 2) {
		var pLen = frm.sid.length;

		if (frm.sel_all.checked) {
			for(i=0;i<pLen;i++) { frm.sid[i].checked = true; }
		} else {
			for(i=0;i<pLen;i++) { frm.sid[i].checked = false;}
		}
	} else if(listCnt == 1) {
		if (frm.sel_all.checked) {
			frm.sid.checked = true;

		} else {
			frm.sid.checked = false;

		}
	} else {

		frm.sel_all.checked = false;
	}
}
</Script>
</body>
</html>


