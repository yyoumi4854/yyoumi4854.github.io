<!-- #include virtual="/myoffice/common/db_connect.inc" -->
<!-- #include virtual="/myoffice/common/function.inc"-->
<link rel="Stylesheet" type="text/css" href="/myoffice/css/basic.css" />
<link rel="Stylesheet" type="text/css" href="/myoffice/css/admin.css" />

<link rel="stylesheet" href="https://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" media="all" />
<style type="text/css">
	td, th, table, body, textarea, select, input, dt, dd {
		font-size: 12px;
		font-family:"나눔고딕", NanumGothic;
	}
	select {
		padding: 1px 30px 1px 3px;
	}
	textarea {
		width:100%;
		height:100px;
	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
<script src="https://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
<script type="text/javascript" src="/bbs/NEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script>
$(document).ready(function() {

	$("#sale_start, #sale_end").datepicker({
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
		$(".tr_beauty").css('display','none');
		$(".tr_health").css('display','none');
		$(".tr_user").css('display','none');

   function readURL(input,idName) {
		if (input.files && input.files[0]) {
			var reader = new FileReader(); //파일을 읽기 위한 FileReader객체 생성
			reader.onload = function (e) {
			//파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
				$('#'+idName).attr('src', e.target.result);
				//이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
				//(아래 코드에서 읽어들인 dataURL형식)
			}
			reader.readAsDataURL(input.files[0]);
			//File내용을 읽어 dataURL형식의 문자열로 저장
		}
	}//readURL()--

	//file 양식으로 이미지를 선택(값이 변경) 되었을때 처리하는 코드
	$(".imgInp2").change(function(){

		var idName="";
		if (this.id =='imgFile1')
		{
			idName='blah1';
		}else if (this.id =='imgFile2')
		{
			idName='blah2';
		}
		else if (this.id =='imgFile3')
		{
			idName='blah3';
		}
		else if (this.id =='imgFile4')
		{
			idName='blah4';
		}
		else if (this.id =='imgFile5')
		{
			idName='blah5';
		}
		else if (this.id =='imgFile6')
		{
			idName='blah6';
		}
		readURL(this,idName);
	});
//	geneCate('','1');

});

function setPdt_add(){
		var tr_cnt	= $("#pdt_opt_table tr").length-1;
	var new_cnt	= tr_cnt + 1;
	var sel_chk = 0;

	if (sel_chk > 0) {
		alert('이미 추가된 상품입니다.');
	} else {


		var addHTML = "";
			addHTML +=	"<tr id=\"item" + new_cnt + "\">";
			addHTML +=	"	<td><input type=\"text\" name=\"gosi_title\" style=\"width:100%;\" class=\"pdt_id\" value=\"\" /></td>";
			addHTML +=	"	<td><textarea type=\"text\" name=\"gosi_content\" rows=\"4\" style=\"width:100%;\" class=\"pdt_id\" value=\"\" /></textarea></td>";
			addHTML +=	"	<td><img src=\"/admin/img/btn_del_red.jpg\" style=\"cursor:pointer;\" onClick=\"item_del(this);\" /></td>";
			addHTML +=	"</tr>";

		$("#pdt_opt_table").append(addHTML);

	}
}

function item_del(obj) {
	$(obj).parent().parent().remove();
}
</script>

<body>
<%

	'Set rs = Server.CreateObject("ADODB.RecordSet")
	'rs.cursortype = 3
	'sql =		"select * from web_popup		"
	'sql = sql & "where regno = '"&regno&"'  "
	'rs.Open sql, DBConn
	'If Not  (rs.Bof and rs.Eof) Then
	'	sid			= rs("regno")
	'	subject		= rs("title")
	'	subject = cut_string(subject,50)
	'	isuse	= rs("isuse")
	'	popup_status= rs("POPUP_STATUS")
	'	isusedate	= rs("isusedate")
	'	st_date	= rs("st_date")
	'	ed_date	= rs("ed_date")

	'	If st_date="" Or IsNull(st_date) Then st_date= "-" End If
	'	If ed_date="" Or IsNull(ed_date) Then ed_date= "-" End If

	'rs.Close : Set rs = Nothing
	'end If

%>
	<div id="wrap">

		<div id="admin_con_area">

			<div class="admin_contents">
				<!---- 콘텐츠 현재 위치 ----->

				<!--###################### 내용 #########################-->
				<!---- 회원정보 ----->
				<h3 class="admin_title">상품 등록</h3>
				<!-------------------회원정보------------------>
				<form name="reg_frm" id="reg_frm" method="post"  enctype="multipart/form-data" >
				<input type="hidden" name="send_chk" id="send_chk" value="" >
				<input type="hidden" name="pdt_content" id="pdt_content" value="" >
				<table width="800" border="0" cellspacing="0" cellpadding="0" class="join_tb">
					<colgroup>
						<col style="width:15%;">
						<col style="width:35%;">
						<col style="width:15%;">
						<col style="width:35%;">
					</colgroup>
					<tr>
						<th scope="row">판매명 기능성</th>
						<td>
							<input	type="text" name="subject" id="subject"  class="input" style="width:100%;">
						</td>
						<th scope="row">제품선택</th>
						<td>
							<select name="product_cd" id="product_cd" class="select" onchange="selPdtName();">
								<option value="--">==========선택==========</option>
								<%
									Set rsItem = Server.CreateObject("ADODB.RecordSet")
									sql =			" Select					"
									sql =	sql &	" *							"
									sql =	sql &	" from PRODUCT a			"
									'sql =	sql &	" where a.product_cd not in (select b.product_cd from PDT_WEBINFO b)  "
									sql =	sql &	" order by product_name asc  "

										rsItem.Open sql, DBConn
										If Not  (rsItem.Bof and rsItem.Eof) Then
											Do While (Not rsItem.eof)
												product_cd	= rsItem("PRODUCT_CD")
												product_name = rsitem("PRODUCT_NAME")
												cate_cd1	= rsItem("cate_cd1")
												isweb		= rsItem("isweb")
												%>
												<option value="<%=product_cd%>" data-cate="<%=cate_cd1%>" data-isweb="<%=isweb%>">(<%=product_cd%>) <%=product_name%></option>
												<%
											rsItem.movenext
											Loop
										End If
										rsItem.Close : Set rsItem = Nothing
								%>
							</select>
							<input	type="text" name="product_name" id="product_name"  class="input" style="width:100%;">
						</td>
						</tr>
						<tr>
				  					<th scope="row">카테고리</th>
				  					<td colspan="3">
				  						<select name="pdt_cate1" id="pdt_cate1" class="select"  ><!-- onchange="chg_cate1();" -->
										<%
										Set rsCate = Server.CreateObject("ADODB.RecordSet")
										sql =			" Select cate_cd1, cate_name		"
										sql =	sql &	"   from pdt_cate1 a				"
										sql =	sql &	"  where a.isuse = '1'				"
										sql =	sql &	"    and a.cate_cd1 <> '6'			"
										sql =	sql &	"  order by view_order, cate_cd1 asc"
										rsCate.Open sql, DBConn
										If Not  (rsCate.Bof and rsCate.Eof) Then
											Do While (Not rsCate.eof)
												cate_cd = rsCate("cate_cd1")
												cate_name = rsCate("cate_name")
												%>
												<option value="<%=cate_cd%>">(<%=cate_cd%>) <%=cate_name%></option>
												<%
											rsCate.movenext
											Loop
										End If
										rsCate.Close : Set rsCate = Nothing
										%>
				  						</select>
				  						<select name="pdt_cate2" id="pdt_cate2" class="select" style="display:none;">
				  						</select>

				  					</td>

				  </tr>
				  <tr>
				  					<th scope="row">우선순위</th>
				  					<td colspan="3">
										<input type="text" name="view_order" id="view_order" value="1">
				  					</td>

				  </tr>
				  <tr>
				  					<th scope="row">판매여부</th>
				  					<td colspan="3">
				  						<select name="issale" id="issale" class="select">
				  							<option value="0">보류</option>
				  							<option value="1" Selected>판매</option>

				  						</select>

				  					</td>
				  </tr>

				  <tr>
				  					<th scope="row">웹게시</th>
				  					<td colspan="3">
				  						<select name="pdt_isuse" id="pdt_isuse" class="select">
				  							<option value="0">보류</option>
				  							<option value="1" Selected>게시</option>

				  						</select>

				  					</td>

				  </tr>

				  <tr>
					<th scope="row">상세내용</th>
					<td colspan="3">
					<textarea	id="msg_body" name="msg_body" style="display:none;height:100px;width:100%;min-width:260px;"><%=contents%></textarea>
					</td>
				  </tr>
					<tr>
				  		<th scope="row">제품고시정보 타입</th>
				  		<td colspan="3">
							<select name="notify_cd" id="notify_cd" class="select" onchange="chg_nodify(this.value);">
								<option value="">미등록</option>
								<option value="BEAUTY">화장품</option>
								<option value="HEALTH">건강식품</option>
								<option value="USER">직접입력</option>
							</select>
				  		</td>
					</tr>
					<!-- 화장품 s-->
					<tr class="tr_beauty">
				  		<th scope="row">포장단위별 용량, 수량</th>
				  		<td colspan="3">
							<textarea name="pdt_volume" id="pdt_volume"  class="input" value="<%=pdt_volume%>"></textarea>
				  		</td>
					</tr>
					<tr class="tr_beauty">
						<th scope="row">제조업소의 명칭과 소재지</th>
						<td colspan="3">
							<textarea name="pdt_company" id="pdt_company" value="<%=pdt_company%>"></textarea>
						</td>
					</tr>
					<tr class="tr_beauty">
						<th scope="row">제조연월일, 유통기한 또는 품질유지기한</th>
						<td colspan="3">
							<textarea name="pdt_limit" id="pdt_limit" value="<%=pdt_limit%>"></textarea>
						</td>
					</tr>
					<tr class="tr_beauty">
						<th scope="row">전성분</th>
						<td colspan="3">
							<textarea	id="pdt_ingredient" name="pdt_ingredient" value="<%=pdt_ingredient%>"></textarea>
						</td>
					</tr>
					<tr class="tr_beauty">
						<th scope="row">사용방법</th>
						<td colspan="3">
							<textarea name="pdt_manual" id="pdt_manual" value="<%=pdt_manual%>"></textarea>
						</td>
					</tr>
					<tr class="tr_beauty">
						<th scope="row">사용 시 주의사항</th>
						<td colspan="3">
							<textarea name="pdt_attention" id="pdt_attention" value="<%=pdt_attention%>"></textarea>
						</td>
					</tr>
					<!--//화장품 e-->

					<!-- 식품 s-->
					<tr class="tr_health">
						<th scope="row">식품의 유형</th>
						<td colspan="3">
							<textarea name="pdt_food_type" id="pdt_food_type" value="<%=pdt_food_type%>"></textarea>
						</td>
					</tr>
					<tr class="tr_health">
						<th scope="row">제조업소의 명칭과 소재지</th>
						<td colspan="3">
							<textarea name="pdt_food_producer" id="pdt_food_producer" value="<%=pdt_food_producer%>"></textarea>
						</td>
					</tr>
					<tr class="tr_health">
						<th scope="row">제조연월일, 유통기한 또는 품질유지기한</th>
						<td colspan="3">
							<textarea name="pdt_food_limit" id="pdt_food_limit" value="<%=pdt_food_limit%>"></textarea>
						</td>
					</tr>
					<tr class="tr_health">
				  		<th scope="row">포장단위별 용량, 수량</th>
				  		<td colspan="3">
							<textarea name="pdt_food_weight" id="pdt_food_weight"  class="input" value="<%=pdt_food_weight%>"></textarea>
				  		</td>
					</tr>
					<tr class="tr_health">
						<th scope="row">원재료명 및 함량</th>
						<td colspan="3">
							<textarea	id="pdt_food_ingredient" name="pdt_food_ingredient" value="<%=pdt_food_ingredient%>"></textarea>
						</td>
					</tr>
					<tr class="tr_health">
						<th scope="row">영양정보</th>
						<td colspan="3">
							<textarea name="pdt_food_material" id="pdt_food_material" value="<%=pdt_food_material%>"></textarea>
						</td>
					</tr>
					<tr class="tr_health">
						<th scope="row">기능정보</th>
						<td colspan="3">
							<textarea name="pdt_food_function" id="pdt_food_function" value="<%=pdt_food_function%>"></textarea>
						</td>
					</tr>
					<tr class="tr_health">
						<th scope="row">섭취량, 섭취방법 및 섭취 시 주의사항 및 부작용 가능성</th>
						<td colspan="3">
							<textarea	id="pdt_food_nutrition" name="pdt_food_nutrition" value="<%=pdt_food_nutrition%>"></textarea>
						</td>
					</tr>
					<!--//식품 e-->
					<tr class="tr_user">
						<th scope="row">제품고시정보<br />직접추가</th>
						<td colspan="3">
							<div>
								<img src="/admin/img/btn_add_blue.jpg" id="btn_addpdt" onclick="setPdt_add()" />
								&nbsp;<b style="color:red;">고시정보 전체 문자가 2,000자를 넘을 경우 관리자에게 문의 하세요.</b>
							</div>
							<div>
								<table id="pdt_opt_table" style="width:100%;">
									<colgroup>
										<col style="width:25%;">
										<col style="width:60%;">
										<col style="width:15%;">
									</colgroup>
									<tbody>
									<tr>
										<th>고시 제목</th>
										<th>고시 내용</th>
										<th>삭제</th>
									</tr>
									</tbody>
								</table>
							</div>
						</td>
					</tr>
				  <tr>
					<th scope="row">이미지</th>
					<td colspan="3">
					<!--- 옵션값 입력 및 삭제 --->
								<table width="500" >
									<colgroup>
										<col style="width:50px">
										<col style="width:100px">
									</colgroup>
									<tr>
										<th>메인큰 이미지</th>
										<th>메인중간 이미지</th>

									</tr>
									<tr>
										<td><img id="blah1" src="../img/m_bg_mplan.gif" alt="이미지가 없습니다." style="width:100px;" /></td>
										<td><img id="blah2" src="../img/m_bg_mplan.gif" alt="이미지가 없습니다." style="width:100px;"/></td>

									</tr>
									<tr>
										<td><input type='file' id="imgFile1" name="upfile1" class="imgInp2" /></td>
										<td><input type='file' id="imgFile2" name="upfile2" class="imgInp2" /></td>
									</tr>

									<tr>

										<th>리스트 이미지</th>
										<th>썸네일 이미지</th>
									</tr>
									<tr>
										<td><img id="blah3" src="../img/m_bg_mplan.gif" alt="이미지가 없습니다." style="width:100px;"/></td>
										<td><img id="blah4" src="../img/m_bg_mplan.gif" alt="이미지가 없습니다." style="width:100px;"/></td>
									</tr>
									<tr>
										<td><input type='file' id="imgFile3" name="upfile3" class="imgInp2" /></td>
										<td><input type='file' id="imgFile4" name="upfile4" class="imgInp2" /></td>
										</tr>

								</table>
								<!--- 옵션값 입력 및 삭제 --->

					</td>
				  </tr>
				</table>
				</form>
				<div class="btn_center">
					<a href="#" id="btn_submit"><img src="../img/btn_save.gif" style="cursor:pointer;" onClick="frm_chk();"/></a>
					<a href="#"><img src="../img/btn_cancel.gif" style="cursor:pointer;" onClick="javascript:history.back();" /></a>
				</div>
			<!-------------------회원가입폼------------------>

			<!--###################### 내용 #########################-->
			<iframe id="proc_fr" name="proc_fr" width="100%" height="300px" ></iframe>
			</div>
		</div>
		<!--------------------------------- 푸터 --------------------------->
	<script language="javascript">

	</script>
	</div>
	<!-- display:none; -->
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
//var oEditors2 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors2,
//	elPlaceHolder: "pdt_material",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//var oEditors3 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors3,
//	elPlaceHolder: "pdt_attention",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//
//
//
//var oEditors4 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors4,
//	elPlaceHolder: "pdt_food_producer",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//var oEditors5 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors5,
//	elPlaceHolder: "pdt_food_material",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//var oEditors6 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors6,
//	elPlaceHolder: "pdt_food_nutrition",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//var oEditors7 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors7,
//	elPlaceHolder: "pdt_food_attention",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//var oEditors8 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors8,
//	elPlaceHolder: "pdt_food_function",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//// 20170904 jyd 추가
//var oEditors11 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors11,
//	elPlaceHolder: "pdt_effect",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//var oEditors12 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors12,
//	elPlaceHolder: "pdt_chara",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});

//var oEditors13 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors13,
//	elPlaceHolder: "pdt_manual",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});
//
//var oEditors14 = [];
//nhn.husky.EZCreator.createInIFrame({
//	oAppRef: oEditors14,
//	elPlaceHolder: "pdt_ingredient",
//	sSkinURI: "/bbs/NEditor/SmartEditor2Skin.html",
//	htParams : {
//		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
//		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
//		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
//		fOnBeforeUnload : function(){
//		}
//	}, //boolean
//	fOnAppLoad : function(){
//		//예제 코드
//		//oEditors.getById["msg_body"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
//	},
//	fCreator: "createSEditor2"
//});








//---------------------------------------------------------------------- EDITOR INSERT END

var frm = document.reg_frm;

function frm_chk() {

	var proc_ok = "T";

	oEditors.getById["msg_body"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.

//	oEditors2.getById["pdt_material"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors3.getById["pdt_attention"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//
//	oEditors4.getById["pdt_food_producer"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors5.getById["pdt_food_material"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors6.getById["pdt_food_nutrition"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors7.getById["pdt_food_attention"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors8.getById["pdt_food_function"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//
//	oEditors11.getById["pdt_effect"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors12.getById["pdt_chara"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors13.getById["pdt_manual"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
//	oEditors14.getById["pdt_ingredient"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.


//	if(document.getElementById('subject').value == ""  ){
//		alert("상품명을 입력해주십시오.");
//		document.getElementById('subject').focus();
//		proc_ok = "F";
//		return false;
//	}else
	if($("#product_cd option:selected").val()=='--'){
		alert("제품을 선택해주세요.");
		document.getElementById('product_cd').focus();
		proc_ok = "F";
		return false;
	}/*else if($("#cate_list1 option:selected").val()=='--' ||$("#cate_list2 option:selected").val()=='--' ||$("#cate_list3 option:selected").val()=='--' ){
		alert("분류를  선택해주세요.");
		document.getElementById('cate_list1').focus();
		proc_ok = "F";
		return false;
	}else if($("#sale_start").val()=='' ||$("#sale_end").val()==''){
		alert("판매기간을  선택해주세요.");
		document.getElementById('sale_start').focus();
		proc_ok = "F";
		return false;
	}else if(document.getElementById('msg_body2').value == "<P>&nbsp;</P>" || document.getElementById('msg_body2').value == "" ){
		alert("배송/교환/반품정보를  입력해주십시오.");
		document.getElementById('msg_body2').focus();
		proc_ok = "F";
		return false;
	}*/else if(document.getElementById('msg_body').value == "<P>&nbsp;</P>" || document.getElementById('msg_body').value == "" ){
		alert("글내용을 입력해주십시오.");
		document.getElementById('msg_body').focus();
		proc_ok = "F";
		return false;
	}

	var temp_pdt_content = fn_gosi_data();
	if (temp_pdt_content){
		$("#pdt_content").val(temp_pdt_content);
	}


	if (proc_ok == "T")	{
		allSelectItem();
		//document.getElementById("btn_submit").style.display = "none";
		frm.target	="proc_fr";
		frm.action	= "./product_product_write_ok.asp";
		frm.submit();
	}
}


function chkOptName()
{

	var i= $(".op_item_name").get().length;
	var chkVal=true;
	for(a=0;a<i;a++){
		if ($(".op_item_name:eq("+a+")").val() =='')
		{
			$(".op_item_name:eq("+a+")").focus();
			chkVal=false;
		}
	}

	return chkVal;
}
function chkOptItem()
{
	var chkVal=true
	var rOptionCnt = $("#optionRightList option").length;
	if (rOptionCnt==0)
	{
		chkVal=false;
	}

	return chkVal;
}



function getProductList(){
	$.ajax({
		url:"/admin/inc/json_product_list.asp",
		global:false,
		contentType : 'application/json; charset=utf-8',
		type:"GET",
		data:{searchKey:$("#op_searchKey").val(),searchVal:$("#op_searchVal").val()},
		dataType: 'json',
		async:true,

		success:function(data){
			var dataMaxCnt =data.length;

			if (dataMaxCnt =='0')
			{
				alert('검색된 내용이 없습니다.');
			}else{
				$("#optionLeftList").empty();
				for (a=0;a<dataMaxCnt ;a++ )
				{
					$("#optionLeftList").append("<option value='"+data[a].PRODUCTSHOP_CD+"'>["+data[a].PRODUCTSHOP_CD+"]"+data[a].PRODUCTSHOP_NAME+"</option>");
				}
			}

		},
		error:function(reponse,textStatus,errorThrown){
			alert(errorThrown);
		},
		beforeSend:function(){

		}
	});
}

function addSelectItem(){

var optionVal = '';
var optionText = '';
var checkText = '';
var lOptionCnt = $("#optionLeftList option").length;
var rOptionCnt = $("#optionRightList option").length;
var isClean=true;

	if (lOptionCnt==0)
	{
		alert('옵션을 검색해 주세요.');
	}else{
		for (b=0;b<lOptionCnt ;b++ )
		{
			if ($("#optionLeftList :eq("+b+")").attr("selected") =='selected')
			{
				optionVal = $("#optionLeftList :eq("+b+")").val();
				optionText= $("#optionLeftList :eq("+b+")").text();
				for (a=0;a<rOptionCnt;a++ )
				{
					if (optionVal== $("#optionRightList :eq("+a+")").val())
					{
						isClean=false;
						checkText= optionText;
					}
				}
				if (isClean)
				{

					$("#optionRightList").append("<option value='"+optionVal+"'>"+optionText+"</option>");
				}else{
					alert(checkText+'은 이미 선택된 값입니다.');
					isClean=true;
					checkText="";
				}

			}
		}
	}
}
function removeSelectItem(){
	var rOptionCnt = $("#optionRightList option").size()-1;

	for (b=rOptionCnt;b>=0 ;b-- )
	{
		if ($("#optionRightList :eq("+b+")").attr("selected") =='selected')
		{

			$("#optionRightList :eq("+b+")").remove();
		}
	}
}

function allSelectItem(){
	var rOptionCnt = $("#optionRightList option").size()-1;

	for (b=rOptionCnt;b>=0 ;b-- )
	{
		$("#optionRightList :eq("+b+")").attr("selected","selected");
	}
}

//리스트 불러오기 분기
function geneCate(selVal,depth){
	if (depth=='1')
	{
		getOptionList('cate_list1','',1,'');
	}else if (depth=='2')
	{
		if (selVal == '')
		{
			selVal = $("#cate_list1 option:selected").val();
		}
		getOptionList('cate_list2','',2,selVal);
	}else if (depth=='3')
	{
		if (selVal == '')
		{
			selVal = $("#cate_list2 option:selected").val();
		}
		getOptionList('cate_list3','',3,selVal);
	}

}
//리스트 호출
function getOptionList(setId,cateCd,cateLv,parentCd){


	$.ajax({
		url:"/admin/inc/json_cate_list.asp",
		global:false,
		contentType : 'application/json; charset=utf-8',
		type:"GET",
		data:{cate_cd:cateCd,cate_lv:cateLv,parent_cd:parentCd},
		dataType: 'json',
		async:true,

		success:function(data){
			var dataMaxCnt =data.length;

			$("#"+setId).empty();
			$("#"+setId).append("<option value='--'>=======선택=======</option>");
			if (cateLv =='2')
			{
				$("#sortable3").empty();
			}


			if (dataMaxCnt =='0')
			{
				//alert('검색된 내용이 없습니다.');
			}else{

				for (a=0;a<dataMaxCnt ;a++ )
				{

					$("#"+setId).append("<option value='"+data[a].CATE_CD+"'>"+data[a].CATE_NAME+"</option>");
					//$("#"+setId).append(setLoadItem(data[a].CATE_CD,data[a].CATE_NAME,data[a].VIEW_ORDER,cateLv+1,data[a].PARENT_CD));

				}

			}
			//더하기 영역 추가

			//setinit();



		},
		error:function(reponse,textStatus,errorThrown){
			alert(errorThrown);
		},
		beforeSend:function(){

		}
	});
}
function selPdtName()
{
	var $product_cd = $("#product_cd option:selected");
	var pdt_cd = $product_cd.val();
	if (pdt_cd == '--')
	{
		pdtName='';
	}else{
		pdtName=$("#product_cd option:selected").text();
		$("#pdt_cate1").val($product_cd.attr("data-cate"));
		$("#pdt_isuse").val($product_cd.attr("data-isweb"));
	}
	$("#product_name").val(pdtName);
}
function chg_cate1(){
	if ($("#pdt_cate1 option:selected").val()=='HCARE')
	{
		$("#pdt_cate2").css("display","none");

	}else if($("#pdt_cate1 option:selected").val()=='BCARE') {

		add_cate2();
		$("#pdt_cate2").css("display","");
	}else{
		$("#pdt_cate2").css("display","none");
	}
}
function add_cate2(){
	$("#pdt_cate2").find("option").remove();
	$("#pdt_cate2").append("<option value='AGE_DNA'>에이지+디엔에이</option>");
	$("#pdt_cate2").append("<option value='ATO_DNA'>아토+디엔에이</option>");
	$("#pdt_cate2").append("<option value='CELL_POWER'>셀파워</option>");
	$("#pdt_cate2").append("<option value='BODY_HAIR'>바디&헤어</option>");
}

function chg_nodify(selID){
	$(".tr_beauty").css('display','none');
	$(".tr_health").css('display','none');
	$(".tr_user").css('display','none');

	if (selID=='BEAUTY')
	{
		$(".tr_beauty").css('display','');
		return true;
	}else if (selID=='HEALTH')
	{
		$(".tr_beauty").css('display','');
		return true;
	}else if (selID=='USER'){
		$(".tr_user").css('display','');
		return true;
	}else{

	}
}
</script>
</body>
</html>