
<!-- #include virtual ="/myoffice/common/common.inc" -->
<!-- #include virtual ="/myoffice/common/bbs_common.inc" -->
<!-- #include virtual ="/bbs/freeaspupload.html" -->
<%
Response.charset = "utf-8"
Session.CodePage=65001

'On Error Resume Next

'====================파일 업로드 부분 ===========================
  Dim uploadsDirVar
  Dim Upload, fileName, fileSize, ks, i, fileKey,webPath,fileIndex,arrFileName
  webPath = "/bbs/upload"
  uploadsDirVar =  Server.mappath(webPath)
  Set Upload = New FreeASPUpload
  Upload.Save(uploadsDirVar) '파일 업로드

	ks = Upload.UploadedFiles.keys
	if (UBound(ks) <> -1) Then
		If UBound(ks) < 5 Then
			ReDim arrFileName(5)
		Else
			ReDim arrFileName(UBound(ks))
		End If
		fileIndex=0
		for each fileKey in Upload.UploadedFiles.keys
			arrFileName(fileIndex) = webPath &"/"& Upload.UploadedFiles(fileKey).FileName 	'파일명 가져옴
			fileIndex=fileIndex+1
		Next
	Else
		ReDim arrFileName(5)
	end If

'====================파일 업로드 부분 =============================

	userid				= session("admin"): If userid	= "" Then userid="admin" End If
	username			= TRIM(Upload.Form("username"))

	subject				= Upload.Form("subject")
	product_cd			= TRIM(Upload.Form("product_cd"))
	product_name		= TRIM(Upload.Form("product_name"))
	cate_list1			= TRIM(Upload.Form("cate_list1"))
	cate_list2			= TRIM(Upload.Form("cate_list2"))
	cate_list3			= TRIM(Upload.Form("cate_list3"))
	option_cd			= TRIM(Upload.Form("option_cd"))
	pdt_isview			= TRIM(Upload.Form("pdt_isview"))
	pdt_isstock			= TRIM(Upload.Form("pdt_isstock"))
	pdt_ispoint			= TRIM(Upload.Form("pdt_ispoint"))
	pdt_min_qty			= TRIM(Upload.Form("pdt_min_qty"))
	pdt_max_qty			= TRIM(Upload.Form("pdt_max_qty"))
	deliDefault			= TRIM(Upload.Form("deliDefault"))
	deliDefault			= TRIM(Upload.Form("deliDefault"))
	pdt_cate1			= TRIM(Upload.Form("pdt_cate1"))
	pdt_cate2			= TRIM(Upload.Form("pdt_cate2"))
	issale				= TRIM(Upload.Form("issale"))

	view_order			= TRIM(Upload.Form("view_order"))

	notify_cd				= TRIM(Upload.Form("notify_cd"))
	pdt_company				= TRIM(Upload.Form("pdt_company"))
	pdt_origin				= TRIM(Upload.Form("pdt_origin"))
	pdt_material			= TRIM(Upload.Form("pdt_material"))		: pdt_material			= Replace(Replace(pdt_material, """", "&#34;"), "'","&#39;")
	pdt_attention			= TRIM(Upload.Form("pdt_attention"))		: pdt_attention			= Replace(Replace(pdt_attention, """", "&#34;"), "'","&#39;")
	pdt_warranty			= TRIM(Upload.Form("pdt_warranty"))
	pdt_limit				= TRIM(Upload.Form("pdt_limit"))
	pdt_judge				= TRIM(Upload.Form("pdt_judge"))

	pdt_food_type			= TRIM(Upload.Form("pdt_food_type"))
	pdt_food_weight			= TRIM(Upload.Form("pdt_food_weight"))
	pdt_food_producer		= TRIM(Upload.Form("pdt_food_producer"))	: pdt_food_producer		= Replace(Replace(pdt_food_producer, """", "&#34;"), "'","&#39;")
	pdt_food_limit			= TRIM(Upload.Form("pdt_food_limit"))
	pdt_food_material		= TRIM(Upload.Form("pdt_food_material"))	: pdt_food_material		= Replace(Replace(pdt_food_material, """", "&#34;"), "'","&#39;")
	pdt_food_nutrition		= TRIM(Upload.Form("pdt_food_nutrition"))	: pdt_food_nutrition	= Replace(Replace(pdt_food_nutrition, """", "&#34;"), "'","&#39;")
	pdt_food_function		= TRIM(Upload.Form("pdt_food_function"))	: pdt_food_function		= Replace(Replace(pdt_food_function, """", "&#34;"), "'","&#39;")
	pdt_food_gene			= TRIM(Upload.Form("pdt_food_gene"))
	pdt_food_attention		= TRIM(Upload.Form("pdt_food_attention"))	: pdt_food_attention	= Replace(Replace(pdt_food_attention, """", "&#34;"), "'","&#39;")


	pdt_view_hit		= TRIM(Upload.Form("pdt_view_hit"))	: If pdt_view_hit	= "" Then pdt_view_hit="0" End If
	pdt_view_new		= TRIM(Upload.Form("pdt_view_new"))	: If pdt_view_new	= "" Then pdt_view_new="0" End If
	pdt_view_best		= TRIM(Upload.Form("pdt_view_best"))	: If pdt_view_best	= "" Then pdt_view_best="0" End If
	pdt_view_sale		= TRIM(Upload.Form("pdt_view_sale"))	: If pdt_view_sale	= "" Then pdt_view_sale="0" End If
	pdt_view_event		= TRIM(Upload.Form("pdt_view_event"))	: If pdt_view_event	= "" Then pdt_view_event="0" End If
	content				= TRIM(Upload.Form("msg_body"))		: content	= Replace(Replace(content, """", "&#34;"), "'","&#39;")
	deilInfo			= TRIM(Upload.Form("msg_body2"))		: deilInfo	= Replace(Replace(deilInfo, """", "&#34;"), "'","&#39;")

	pdt_isuse			= TRIM(Upload.Form("pdt_isuse"))
	pdt_volume			= TRIM(Upload.Form("pdt_volume"))
	optionRightList		= TRIM(Upload.Form("optionRightList"))
	pdt_keyword			= TRIM(Upload.Form("pdt_keyword"))
	parent_cd			= TRIM(Upload.Form("parent_cd"))
	SALE_START			= TRIM(Upload.Form("sale_start"))
	SALE_END			= TRIM(Upload.Form("sale_end"))

	pdt_effect			= TRIM(Upload.Form("pdt_effect"))		: pdt_effect		= Replace(Replace(pdt_effect, """", "&#34;"), "'","&#39;")
	pdt_chara			= TRIM(Upload.Form("pdt_chara"))		: pdt_chara			= Replace(Replace(pdt_chara, """", "&#34;"), "'","&#39;")
	pdt_manual			= TRIM(Upload.Form("pdt_manual"))		: pdt_manual		= Replace(Replace(pdt_manual, """", "&#34;"), "'","&#39;")
	pdt_ingredient		= TRIM(Upload.Form("pdt_ingredient"))	: pdt_ingredient	= Replace(Replace(pdt_ingredient, """", "&#34;"), "'","&#39;")

	pdt_option			= Trim(Upload.Form("pdt_option"))		: pdt_option		= Replace(pdt_option, " ", "")		: pdt_option		= Replace(pdt_option, ",", "|")

	pdt_usage			= Trim(Upload.Form("pdt_usage"))
	pdt_desc			= Trim(Upload.Form("pdt_desc"))
	pdt_content			= Trim(Upload.Form("pdt_content"))

	sale_start = "2015-01-01"
	sale_end= "3000-01-01"
	parent_cd="1"

	check_str	= subject & userid & content & pdt_keyword
	Err_Msg				= "OK"
	go_upload			= "T"

	If check_injection(check_str) <> "OK" Then
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('특수문자나 명령어는 입력하실 수 없습니다.');"
		Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
		Response.Write "</script>"
		Response.End
	Else


		If Err.Number <> 0 Then
			go_upload	= "F"
			Err_Msg		= "해당 파일을 삽입할 수 없습니다\n이미지의 저장포맷에 문제가 있습니다.\nALSee, AcdSee등을 이용하여 포맷변환해 주십시오."
			Err_Msg		= Err.Description
		End If




		sql	= "select WEBINFO_SEQ.NextVal as NSID from dual "
		Set rs = DBConn.Execute(sql)
			NSid	= rs("NSID")
		rs.Close	: Set rs = Nothing

		Grp	= NSid : Seq = 1 : Lev = 0

		DBConn.BeginTrans

		sql =		"Insert Into PDT_WEBINFO (																						"
		sql = sql &	"	WEBINFO_CD		,	PRODUCT_CD	,		WEBINFO_NAME		,	IMG_L				,	IMG_M			,	"
		sql = sql & "	IMG_S			,	IMG_THUMNAIL,		PDT_VOLUME			,	WORK_USER			,	WORK_DATE		,	"
		sql = sql & "	ISUSE			,	PDT_INFO	,		PDT_CATE1			,	PDT_CATE2			,	VIEW_ORDER		,	"

		sql = sql & "	NOTIFY_CD		,	pdt_company	,		pdt_origin			,	pdt_material		,	pdt_attention	,	"
		sql = sql & "	pdt_warranty	,	pdt_limit	,		pdt_food_type		,	pdt_food_weight		,	pdt_food_producer,	"
		sql = sql & "	pdt_food_limit	,	pdt_food_material,	pdt_food_nutrition	,	pdt_food_function	,	pdt_food_gene	,	"
		sql = sql & "	pdt_food_attention,	pdt_judge,			issale																"

		' sql = sql & "	pdt_effect,		pdt_chara,		pdt_manual,		pdt_ingredient,		pdt_option,								"
		' sql = sql & "	pdt_usage,		pdt_desc,		pdt_content																	"

		sql = sql &	" ) Values (																									"
		sql = sql &	"	LPAD('"& NSid& "',8,'0')	,'"	& product_cd		& "',	'"	& subject			& "',	'"	& arrFileName(0)	& "',	'"	& arrFileName(1)	& "'	,	"
		sql = sql &	"	'"	& arrFileName(2)	& "','"	& arrFileName(3)	& "',	'"	& pdt_volume		& "',	'"	& userid			& "',	sysdate						,	"
		sql = sql &	"   '"	& pdt_isuse			& "','"	& "empty_clob()"	& "',	'"	& pdt_cate1			& "',	'"	& pdt_cate2			& "',	'"	& view_order	& "'	,	"

		sql = sql & "	'"	& notify_cd			& "','"	&pdt_company		& "',	'"	&pdt_origin&		 "',	'"	&pdt_material&		"',	'"	&pdt_attention&		"',	"
		sql = sql & "	'"	& pdt_warranty		& "','"	&pdt_limit			& "',	'"	&pdt_food_type&		 "',	'"	&pdt_food_weight&	"',	'"	&pdt_food_producer& "',	"
		sql = sql & "	'"	& pdt_food_limit	& "','"	&pdt_food_material	& "',	'',	'"	&pdt_food_function& "',	'"	&pdt_food_gene&		"',	"
		sql = sql & "	'"	& pdt_food_attention& "','"	&pdt_judge			& "',	'"	&issale& "' "

		' sql = sql & "	'"	& pdt_effect		& "','"	& pdt_chara			& "',	'"	& pdt_manual	& "','"	& pdt_chara		& "', '" & pdt_option		& "',	"
		' sql = sql & "	'"	& pdt_usage			& "','"	& pdt_desc			& "',	'"	& pdt_content	&"'	"
		sql = sql & " )  "

		DBConn.Execute(sql)


		If DBConn.Errors.Count = 0 Then
		DBConn.CommitTrans
				Set rs_update = Server.CreateObject("ADODB.RecordSet")
				',pdt_material,pdt_attention,pdt_food_producer,pdt_food_material,pdt_food_nutrition,pdt_food_attention
				rs_update.open "select PDT_INFO from PDT_WEBINFO where WEBINFO_CD = LPAD('"& NSid& "',8,'0')" , DBConn, 3,3
				rs_update.fields("PDT_INFO").appendChunk(content)
				'rs_update.fields("pdt_material").appendChunk(pdt_material)
				'rs_update.fields("pdt_attention").appendChunk(pdt_attention)
				'rs_update.fields("pdt_food_producer").appendChunk(pdt_food_producer)
				'rs_update.fields("pdt_food_material").appendChunk(pdt_food_material)
				'rs_update.fields("pdt_food_nutrition").appendChunk(pdt_food_nutrition)
				'rs_update.fields("pdt_food_attention").appendChunk(pdt_food_attention)
				rs_update.update
				rs_update.Close

				Set rs_update2 = Server.CreateObject("ADODB.RecordSet")
				rs_update2.open "select pdt_food_nutrition from PDT_WEBINFO where WEBINFO_CD = LPAD('"& NSid& "',8,'0')" , DBConn, 3,3
				rs_update2.fields("pdt_food_nutrition").appendChunk(pdt_food_nutrition)
				rs_update2.update
				rs_update2.Close

			Response.Write "<script language=javascript>"
			Response.Write "	alert('제품 등록이 완료되었습니다.');"
			Response.Write "	parent.location.href = './product_product.asp';"
			Response.Write "</script>"

		Else
			Response.write Err.Description
			DBConn.RollBackTrans

			msg = err.description : msg = replace(msg,"'","")
			msg = err.description : msg = replace(msg,"""","")

			Response.Write "<script language=javascript>"
			Response.Write "	alert('제품 등록에 실패했습니다.\n\n잠시 후 다시 시도해 주십시오.\n\n사유:" & msg & "');"
			'Response.Write "	parent.document.getElementById('btn_submit').style.display = 'inline';"
			Response.Write "</script>"
		End If

		Set Upload = Nothing
		Response.End

	End If

Function ext_check(ByVal f_name)
	acc_ext = "JPG|JPEG|GIF|BMP|PNG|XLS|XLSX|DOC|DOCX|PPT|PPTX|HWP|TXT|PDF"
	arr_ext = Split(acc_ext,"|")
	f_ext	= UCase(Right(f_name,Len(f_name)-InstrRev(f_name,".")))

	match_cnt = 0

	For fI=0 To UBound(arr_ext)
		IF f_ext = arr_ext(fI) Then match_cnt = match_cnt + 1
	Next

	If match_cnt = 0 Then
		ext_check = "F:FAIL"
	Else
		Select Case f_ext
			Case "JPG","JPEG","GIF","BMP","PNG"	: ext_check = "T:IMG"
			Case Else							: ext_check = "T:DOC"
		End Select
	End If
End Function
%>

