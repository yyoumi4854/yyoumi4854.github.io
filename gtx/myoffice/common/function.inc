<%
'------------------------------------------------------------------------------
'-- 로그인 상태 체크
'-- 호출방법 : call Check_Login(이동할URL)
'-- 이동할 URL은 절대 경로로 써줄 것 (예: "/member/login.asp")
'------------------------------------------------------------------------------
Sub Check_Login(url)
	If url = "" Then url = "/"

	If Session("admin") = "" And session("userid") = "" Then
		msg =		"회원로그인을 하셔야만 이용하실 수 있습니다." & "\n"
		msg = msg & "로그인 페이지로 이동합니다."

		bef_url = Request.ServerVariables("path_info")
		If Request.ServerVariables("query_string") <> "" Then bef_url = bef_url & "?" & Request.ServerVariables("query_string")

		Response.Cookies("before_page").Expires	= Date() + 1
		Response.Cookies("before_page")	= bef_url

		Response.Write "<script language='javascript'>"
		Response.Write "	alert('" & msg & "');"
		Response.Write "	top.location.href = '" & url & "';"
		Response.Write "</script>"
		Response.End
	End If

End Sub


Function fn_cyber_amt(fUSERID)

	sql =		"select	userid, sum(tot_amt) as cyber_amt			"
	sql = sql & "  from	cyber_wallet								"
	sql = sql & " where	avail_date <= to_char(sysdate,'yyyy-mm-dd')	"
	sql = sql & "   and	userid = '" & fUSERID & "'					"
	sql = sql & " group by userid									"
	Set rs_cyber = DBConn.Execute(sql)

	If rs_cyber.Eof Then
		fn_cyber_amt = 0
	Else
		fn_cyber_amt = rs_cyber("cyber_amt")
	End If

	rs_cyber.Close

End Function

Function fn_request_cnt(fUSERID)

	On Error Resume Next

	sql =		"select	count(*) as req_cnt													"
	sql = sql & "  from	cyber_wallet														"
	sql = sql & " where	userid = '" & fUSERID & "'											"
	sql = sql & "   and	cyber_kind = '6202'													"
	sql = sql & "   and	inout_kind = 'O'													"
	sql = sql & "   and	to_char(work_date,'yyyy-mm-dd') = to_char(sysdate,'yyyy-mm-dd')		"
	Set rs_cnt = DBConn.Execute(sql)
		req_cnt = rs_cnt("req_cnt")
	rs_cnt.Close

	fn_request_cnt = req_cnt

End Function

'------------------------------------------------------------------------------
'-- 경고창 띄우기 (call alert("띄울 문자열")
'------------------------------------------------------------------------------
Sub Alert(strMsg)
    Dim strScript

	strMsg		= Replace(strMsg, "'", "")
	strMsg		= Replace(strMsg, """", "")
	strScript	= ""
    strScript	= "<script language='javascript'>"    & vbCrLf &_
				  "   alert('" & strMsg & "');"       & vbCrLf &_
				  "</script>"                         & vbCrLf
    Response.Write strScript
End Sub

'------------------------------------------------------------------------------
'-- Request.Form 배열 분리하기
'------------------------------------------------------------------------------
Function SplitForm(ByRef oForm)
    If Not(IsObject(oForm)) Then
        SplitForm = Null
        Exit Function
    End If

    Dim returnArr()
    Redim returnArr(oForm.Count)
    For i = 1 To oForm.Count
        returnArr(i) = oForm(i)
    Next

    SplitForm = returnArr
End Function

'------------------------------------------------------------------------------
'-- 지정한 페이지로 이동
'------------------------------------------------------------------------------
Sub GoToPage(strPageName)
    Dim strScript
    strScript = ""
    strScript = "<script language='javascript'>"                & vbCrLf &_
                "   location.href = '" & strPageName & "';"     & vbCrLf &_
                "</script>"                                     & vbCrLf
    Response.Write strScript
    Response.End
End Sub

'------------------------------------------------------------------------------
'-- History.Back
'------------------------------------------------------------------------------
Sub GoToBack()
    Dim strScript
    strScript = ""
    strScript = "<script language='javascript'>"                & vbCrLf &_
                "   history.back();"                            & vbCrLf &_
                "</script>"                                     & vbCrLf
    Response.Write strScript
    Response.End
End Sub

'------------------------------------------------------------------------------
'-- 폼 또는 쿼리스트링으로 전달받은 값들을 리스팅
'------------------------------------------------------------------------------
Sub PrintRequest()
    Dim Key

    Response.Write "================ Form =================" & "<br>"
    Response.Write "<table border='1' cellspacing='1'>"
    For Each Key In Request.Form
        Response.Write "<tr>"
        Response.Write "    <td>&nbsp;" & CStr(Key)           & "</td>"
        Response.Write "    <td>&nbsp;" & Request.Form(Key)   & "</td>"
        Response.Write "</tr>"
    Next
    Response.Write "</table><br><br>"

    Response.Write "=============== QueryString==========" & "<br>"
    Response.Write "<table border='1' cellspacing='1'>"
    For Each Key In Request.QueryString
        Response.Write "<tr>"
        Response.Write "    <td>&nbsp;" & CStr(Key)                   & "</td>"
        Response.Write "    <td>&nbsp;" & Request.QueryString(Key)    & "</td>"
        Response.Write "</tr>"
    Next
    Response.Write "</table><br><br>"
'    Response.End
End Sub


'------------------------------------------------------------------------------
'-- DextUpload 폼 개체 보여주기
'------------------------------------------------------------------------------
Sub PrintDext(ByRef oDext)
    Dim item
    For Each item In oDext.Form
        Response.Write item & " = " & oDext.Form(key) & "<br>"
    Next
    Response.End
End Sub

'------------------------------------------------------------------------------
'-- Hidden Form 생성
'------------------------------------------------------------------------------
Sub PrintHidden(ByRef Arguments)
    Dim strHTML
    Dim Key

    strHTML = ""
    strHTML = strHTML & "<!-------------Print Hidden S -------------------------------------------------------->"  & vbCrLf
    For Each Key In Arguments
        strHTML = strHTML & "    <input type='hidden' name='" & CStr(Key) & "' value='" & CStr(Arguments(Key)) & "'>"  & vbCrLf
    Next
    strHTML = strHTML & "<!-------------Print Hidden E -------------------------------------------------------->"  & vbCrLf

    Response.Write strHTML
End Sub

'------------------------------------------------------------------------------
'-- 따옴표 처리 (SQL 쿼리에 적용시 따옴표가 문제될 경우)
'------------------------------------------------------------------------------
Function ReplaceQuotation(ByVal strVal)
    ReplaceQuotation = Replace(Replace(strVal, """", "&#34;"), "'","&#39;")
End Function

'------------------------------------------------------------------------------
'-- SPLIT 함수 사용시 문자열 구분자 이상으로 에러낼 경우를 위해 정규화       --
'-- 호출 : fn_normal(전체문자열,구분자,구분종류)                             --
'-- 리턴 : ","로 구분된 문자열로 리턴하므로 ","로 SPLIT 함수 사용            --
'------------------------------------------------------------------------------
Function fn_normal(full_str,sep_char,sep_kind)
	On Error Resume Next

	If Right(full_str,1) = sep_char Then full_str = Left(full_str,Len(full_str)-1)

	Select Case sep_kind
		Case "TEL"	: lm_cnt = 3
		Case "ZIP"	: lm_cnt = 2
		Case "THUM"	: lm_cnt = 4
		Case "MAIL"	: lm_cnt = 2
		Case Else	: lm_cnt = 0
	End Select

	arr_cnt = 1

	If IsNull(full_str) Then
		For fI = 1 To lm_cnt-1
			ret_str = ret_str & ","
		Next
	ElseIf InStr(full_str,sep_char) > 0 Then
		ret_str = ""
		For fI=1 To Len(full_str)

			If Mid(full_str,fI,1) <> sep_char Then
				ret_str = ret_str & Mid(full_str,fI,1)
			Else
				If arr_cnt < lm_cnt Then
					ret_str = ret_str & ","
				End If
				arr_cnt = arr_cnt + 1
			End If
		Next

		For fL=1 To lm_cnt - arr_cnt
			ret_str = ret_str & ","
		Next
	Else
		If sep_kind = "TEL" Then

			full_str = Trim(full_str)
			Select Case Len(full_str)
				Case 10	: ret_str = Left(full_str,3) & "," & Mid(full_str,4,3) & "," & Right(full_str,4)
				Case 11	: ret_str = Left(full_str,3) & "," & Mid(full_str,4,4) & "," & Right(full_str,4)
				Case 12	: ret_str = Left(full_str,4) & "," & Mid(full_str,5,4) & "," & Right(full_str,4)
				Case Else:
					For tI = 1 To lm_cnt - arr_cnt
						ret_str = ret_str & ","
					Next
			End Select
		Else
			For fL=1 To lm_cnt - arr_cnt
				ret_str = ret_str & ","
			Next
		End If
	End If
	fn_normal = ret_str
End Function


'---------------------------------------------------------------------------------
'-- 랜덤 문자열 생성															--
'-- 호출 : fn_random(타입,생성자릿수) 타입-C:문자만 : N/숫자만 : M:문자숫자혼용 --
'-- 리턴 :																		--
'---------------------------------------------------------------------------------
Function fn_random(ctype,clen)

	Select Case ctype
	Case "C"	: base_str = "abcdefghijklmnopqrstuvwxyz"
	Case "N"	: base_str = "0123456789"
	Case "M"	: base_str = "0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()_+"
	End Select

	Randomize
	rnd_temp = ""
	For I=1 to CInt(clen)
		rnd_length	= Len(base_str)
		rnd_Num		= int(rnd_length*rnd)	: If rnd_Num = 0 Then rnd_Num = 1
		rnd_temp	= rnd_temp & Mid(base_str,rnd_Num,1)
	Next

	fn_random = rnd_temp

End Function

'------------------------------------------------------------------------------
'-- Err Log 기록														     --
'-- 호출 : call fn_errlog													 --
'-- 리턴 :														             --
'------------------------------------------------------------------------------
Sub fn_errlog()

	err_msg = Err.Description
	err_msg = Replace(err_msg,"'","")
	err_msg = Replace(err_msg,"""","")

	sql =		"insert into WEB_ERRLOG (reg_no, err_page, err_desc, remarks)	"
	sql = sql & "values (														"
	sql = sql & ""	& "LOG_SEQ.NextVal"						& ",				"
	sql = sql & "'"	& Request.ServerVariables("path_info")	& "',				"
	sql = sql & "'"	& err_msg								& "',				"
	sql = sql & "'"	& ""									& "')				"
	DBConn.Execute(sql)

End Sub

'------------------------------------------------------------------------------
'-- 문자열 크기 파악													     --
'-- 호출 : STRLen(str)														 --
'-- 리턴 :														             --
'------------------------------------------------------------------------------
Function cut_string(str,ln)
	On Error Resume Next
	curlen = 0
	for i = 1 to len(str)
		curlen = curlen + char_length(mid(str,i,1))
		if curlen >= ln then
			exit for
		end if
	next

	If str <> left(str,i) Then
		cut_string = left(str,i) & ".."
	Else
		cut_string = left(str,i)
	End If
End Function

Function char_length(char)
	tmp = Server.URLEncode(char)
	if len(tmp) = 6 then
		char_length = 2
	else
		char_length = 1
	end if
End Function


'------------------------------------------------------------------------------
'-- SQL Injection 공격 필터												     --
'-- 호출 : Check_Inject(검사할 구문)										 --
'-- 리턴 : 문제없을 경우 OK / 문제있을 경우 경고 띄우고 FAIL	             --
'------------------------------------------------------------------------------
Function check_injection(t_phrase)

'	On Error Resume Next

	exam_str = ""	: inj_cnt = 0

	If t_phrase = "" Then
		For Each Key In Request.Form
			exam_str = exam_str & Request.Form(Key)
		Next

		For Each Key In Request.QueryString
			exam_str = exam_str & Request.QueryString(Key)
		Next

		If IsObject(oDext) Then
			For Each item In oDext.Form
				exam_str = exam_str & oDext.Form(key)
			Next
		End If
	Else
		exam_str = t_phrase
	End If

	filter_key  = "<script |script|/script|or |and |union|delete|select|update |drop table|drop column|alter table|alter column|create |insert|;--|declare|exec|set @"
	filter_sep	= Split(filter_key,"|")
	filter_cnt	= Ubound(filter_sep)

	For M=0 To filter_cnt
		If InStr(exam_str,filter_sep(M)) > 0 Then
			inj_cnt = inj_cnt + 1
		End If
	Next

	If inj_cnt > 0 Then
'		response.write "<script language='javascript'>"
'		response.write "	alert('특수문자나 명령어들은 사용하실 수 없습니다.');"
'		response.write "</script>"
		check_injection = "FAIL"
	Else
		check_injection = "OK"
	End If

End Function


Function fn_masking(fKIND, fVAL)

	On Error Resume Next

	t_str = Replace(Replace(Replace(fVAL,"-","")," ",""),".","")

	Select Case fKIND
	Case "TEL"

		mobile_chk	= "010,011,016,017,018,019"

		If (InStr(mobile_chk,Left(t_str,3)) > 0) Or Left(t_str,4) = "0130" Then
			Select Case Len(t_str)
				Case 10	: ret_str = Left(t_str,3) & "-" & "****" & "-" & Right(t_str,4)
				Case 11	: ret_str = Left(t_str,3) & "-" & "****" & "-" & Right(t_str,4)
				Case 12	: ret_str = Left(t_str,4) & "-" & "****" & "-" & Right(t_str,4)
			End Select
		ElseIf Left(t_str,2) = "02" Then
			ret_str = Left(t_str,2) & "-" & "****" & "-" & Right(t_str,4)
		Else
			ret_str = Left(t_str,3) & "-" & "****" & "-" & Right(t_str,4)
		End If

	Case "RRN"

		ret_str = Left(t_str,6) & "-" & "*******"

	Case "BANK"

		ret_str = Left(t_str,4) & "**********" & Right(t_str,4)

	Case "CARD"

		ret_str = Left(t_str,4) & "-" & "***" & "-" & "****" & "-" & Right(t_str,4)

	End Select

	fn_masking = ret_str


End Function

'------------------------------------------------------------------------------
'-- DB에서 카운트 1 증가												     --
'-- 호출 : update_cnt(field,table)											 --
'-- 리턴 :														             --
'------------------------------------------------------------------------------
Sub update_cnt(ByVal fnKey, ByVal fnID, ByVal fnField, ByVal fnTable)

	sql =		"update	" & fnTable
	sql = sql & "   set " & fnField & " = " & fnField & "+ 1	"
	sql = sql & " where	" & fnKey	& " = " & fnID
	DBConn.Execute(sql)
End Sub

'------------------------------------------------------------------------------
'-- xmlHttp 통신														     --
'-- 호출 : tranHttp(url) url 은 ? 뒤에 쿼리스트링 포함						 --
'-- 리턴 :														             --
'------------------------------------------------------------------------------
Function tranHttp(t_url)
    Set xmlComm = Server.CreateObject("MSXML2.ServerXMLHTTP")
        xmlComm.Open "GET", t_url, False
        xmlComm.Send

		if xmlComm.status = "200" Then
			tranHttp = xmlComm.responseText
		else
			tranHttp = "Error"
		end if

	Set xmlComm = Nothing
End Function



'파일 저장 폴더 명을 가져온다.
Function GetSaveFolderName(ByVal folder)
    Dim strFullFolderName
    strFullFolderName = Server.MapPath("/") & "\" & folder & "\"
    Dim oFso, oF
    Set oFso = Server.CreateObject("Scripting.FileSystemObject")
    If (Not oFso.FolderExists(strFullFolderName) ) Then
        Set oF = oFso.CreateFolder(strFullFolderName)
        GetSaveFolderName = oF.Path
        Exit Function
    End If

    GetSaveFolderName = strFullFolderName
    Exit Function
End Function

'저장 하는 폴더명 가져오기
Function GetSaveFolderNameEx(ByVal strPath)
    Dim strFullFolderName
    strFullFolderName = Server.MapPath("/") & strPath

    Dim oFso, oF
    Set oFso = Server.CreateObject("Scripting.FileSystemObject")
    If (Not oFso.FolderExists(strFullFolderName) ) Then
        Set oF = oFso.CreateFolder(strFullFolderName)
        GetSaveFolderNameEx = oF.Path
        Exit Function
    End If

    GetSaveFolderNameEx = strFullFolderName
    Exit Function
End Function

'폴더명만 분리
Function PathToFolderName(ByRef strPath)
    Dim strFolderName
    Dim nIndex

    nIndex = InStrRev(strPath, "\")
    If nIndex = 0 Then
        PathToFolderName = Null
        Exit Function
    End If

    strFolderName = Left(strPath, CInt(nIndex)-1)
    PathToFolderName = strFolderName
End Function

'파일명만 분리
Function PathToFileName(ByRef strPath)
    Dim strFileName
    Dim nIndex

    nIndex = InStrRev(strPath, "\")
    If nIndex = 0 Then
        PathToFileName = Null
        Exit Function
    End If

    strFileName = Mid(strPath, CInt(nIndex)+1)
    PathToFileName = strFileName
End Function


'------------------------------------------------------------------------------
'-- 게시판 컨텐츠 HTML 표준화											     --
'------------------------------------------------------------------------------
Function regularHTML(fnText)

	If isNull(fnText) = false And isEmpty(fnText) = false And fnText <> "" Then
		convHTML = Replace(fnText,"","&nbsp;")
		convHTML = replace(convHTML,"","&nbsp;")
		convHTML = replace(convHTML, "&amp;" , "&")
		convHTML = replace(convHTML, "&lt;", "<")
		convHTML = replace(convHTML, "&gt;", ">")
		convHTML = replace(convHTML, "&quot;", "'")
		convHTML = replace(convHTML, "``", ";")
		convHTML = replace(convHTML,"''","'")
		convHTML = Replace(convHTML, "&amp;","&")
		convHTML = Replace(convHTML, "&#34;","""")
		regularHTML = convHTML
	End If

End Function


'------------------------------------------------------------------------------
'-- SQL Injection 관련 이상 문자열 발견시 처리							     --
'------------------------------------------------------------------------------
'If check_injection("") <> "OK" Then
'	Response.Write "<script language='javascript'>"
'	Response.Write "alert('입력하신 문자열 중에 허용되지않는 문자가 있습니다.\n확인하신 후 다시 시도해 주십시오');"
'	Response.Write "history.back();"
'	Response.Write "</script>"
'	Response.End
'End If




'------------------------------------------------------------------------------
'-- 이메일 보내기														     --
'// strFrom - 보내는 사람 이메일										     --
'// strTo - 받는 사람 이메일												 --
'// strSubject - 이메일 제목												 --
'// strBody - 이메일 내용													 --
'// bitHtml - True : Html, False : Text										 --
'// ReturnValue - True / False												 --
'------------------------------------------------------------------------------
Function SendMail(strFrom, strTo, strSubject, strBody, bitHtml)
        Set objMail = Server.CreateObject("CDO.Message")
        objMail.From  = strFrom
        objMail.ReplyTo = strFrom
        objMail.To = strTo
        objMail.Subject = strSubject

        If bitHtml Then
            objMail.HTMLBody = strBody
        Else
            objMail.TextBody = strBody
        End If

        objMail.send
        Set objMail = Nothing

End Function

'------------------------------------------------------------------------------
'-- paging 처리																 --
'--aTotPage =전체페이지수
'--aColCount =td갯수
'--aGo_page = 이동페이지 넘버
'--aGroupsize = 그룹수
'--apage_str = 이동 파라미터


'------------------------------------------------------------------------------

sub getPager(aTotPage,aColCount,aGo_page,aGroupsize,apage_str)
	'----------------------------------------------------------------------- Page Number S





	If aTotPage > 1 Then						'가져온 레코드의 갯수가 한 페이지 출력 갯수보다 많을 경우

	%>

	<div class='page_ing' >
			<div class='page_num'>
	<%
		gsize		= CInt(aGroupsize)
		prev_page	= aGo_page - 1
		next_page	= aGo_page + 1
		end_page	= aTotPage


	%>
	<tr class="page_tr">
		<td class="page_td" colspan="4">
	<%
		If prev_page >= 1 Then
			Response.Write "<a href='#' style='border:none;' onClick=""go_page('1','"&apage_str&"');"" title=""첫페이지""	> <img src='/admin/img/btn_arrow_backward.gif' style='vertical-align:middle;' /></a>"
			Response.Write "<a href='#' style='border:none;'	onClick=""go_page('" & prev_page & "','"&apage_str&"');"" title=""이전페이지""><img src='/admin/img/btn_arrow_prev.gif' style='vertical-align:middle;' /></a>"
		Else
			Response.Write "<a href='#' style='border:none;' onClick=""alert('첫페이지입니다.');"" title=""첫페이지""	> <img src='/admin/img/btn_arrow_backward.gif' style='vertical-align:middle;' /></a>"
			Response.Write "<a href='#' style='border:none;'	onClick=""alert('첫페이지입니다.');"" title=""이전페이지""><img src='/admin/img/btn_arrow_prev.gif' style='vertical-align:middle;' /></a>"

		End If

		L_Cnt	= gsize
		P_Cnt	= ((aGo_page-1) \ gsize) * gsize + 1

		Do While (L_Cnt > 0) and (P_Cnt <= aTotPage)

		'현재 페이지의 색상 표현
			If CInt(P_Cnt) = CInt(aGo_page) Then
			Response.Write "<a href='#' class='on' onClick=""go_page('" & P_Cnt & "','"&apage_str&"');"" title=""" & P_Cnt & """>" & P_Cnt & "</a>"
			Else
			Response.Write "<a href='#'  onClick=""go_page('" & P_Cnt & "','"&apage_str&"');"" title=""" & P_Cnt & """ onClick=""go_page('" & P_Cnt & "','"&apage_str&"');"" title=""" & P_Cnt & """  onMouseOver=""this.className='page_num_over';"" onMouseOut=""this.className='page_num_normal';"">" & P_Cnt & "</a>"

			End If

			'Response.Write "<span class=""page_space""></span>"

			P_Cnt	= P_Cnt + 1
			L_Cnt	= L_Cnt - 1
		Loop

		If next_page <= aTotPage Then
			Response.Write "<a href='#' style='border:none;' onClick=""go_page('" & next_page & "','"&apage_str&"');"" title=""다음페이지""><img src='/admin/img/btn_arrow_next.gif' style='vertical-align:middle;' /></a>"
			Response.Write "<a href='#' style='border:none;' onClick=""go_page('" & aTotPage   & "','"&apage_str&"');"" title=""마지막페이지""><img src='/admin/img/btn_arrow_forward.gif' style='vertical-align:middle;' /></a>"
					Else
			Response.Write "<a href='#' style='border:none;' onClick=""alert('마지막페이지입니다');"" title=""다음페이지""><img src='/admin/img/btn_arrow_next.gif' style='vertical-align:middle;' /></a>"
			Response.Write "<a href='#' style='border:none;' onClick=""alert('마지막페이지입니다');"" title=""마지막페이지""><img src='/admin/img/btn_arrow_forward.gif' style='vertical-align:middle;' /></a>"
		End If

			Response.Write "<script>														"
			Response.Write "function go_page(p_num,pageStr) {								"
			Response.Write "	var url_ = '"&apage_str&"&go_page='+ p_num;					"
			Response.Write "	location.href = url_;										"
			Response.Write "}																"
			Response.Write "</script>														"


	%>
		</div>
	</div>
	<%
	End If
	'----------------------------------------------------------------------- Page Number E
End sub

sub getPagerOld(aTotPage,aColCount,aGo_page,aGroupsize,apage_str)
	'----------------------------------------------------------------------- Page Number S
	If aTotPage > 1 Then						'가져온 레코드의 갯수가 한 페이지 출력 갯수보다 많을 경우
	%>
	<tr class="blank_tr"><td colspan="<%=aColCount%>"></td></tr>

	<%
		gsize		= CInt(aGroupsize)
		prev_page	= aGo_page - 1
		next_page	= aGo_page + 1
		end_page	= aTotPage


	%>
	<tr class="page_tr">
		<td class="page_td" colspan="4">
	<%
		If prev_page >= 1 Then
			Response.Write "<span class=""page_end""	onClick=""go_page('1','"&apage_str&"');""				  title=""첫페이지"">◀</span>"
			Response.Write "<span class=""page_next""	onClick=""go_page('" & prev_page & "','"&apage_str&"');"" title=""이전페이지"">이전</span>&nbsp;&nbsp;"
		Else
			Response.Write "<span class=""page_end""	onClick=""alert('첫페이지입니다.');""	  title=""첫페이지"">◀</span>"
			Response.Write "<span class=""page_next""	onClick=""alert('첫페이지입니다.');""	  title=""이전페이지"">이전</span>&nbsp;&nbsp;"
		End If

		L_Cnt	= gsize
		P_Cnt	= ((aGo_page-1) \ gsize) * gsize + 1

		Do While (L_Cnt > 0) and (P_Cnt <= aTotPage)

		'현재 페이지의 색상 표현
			If P_Cnt = aGo_page Then
				Response.Write "<span class=""page_num_current"" onClick=""go_page('" & P_Cnt & "','"&apage_str&"');"" title=""" & P_Cnt & """>" & P_Cnt & "</span>"
			Else
				Response.Write "<span class=""page_num_normal"" onClick=""go_page('" & P_Cnt & "','"&apage_str&"');"" title=""" & P_Cnt & """  onMouseOver=""this.className='page_num_over';"" onMouseOut=""this.className='page_num_normal';"">" & P_Cnt & "</span>"
			End If

			Response.Write "<span class=""page_space""></span>"

			P_Cnt	= P_Cnt + 1
			L_Cnt	= L_Cnt - 1
		Loop

		If next_page <= aTotPage Then
			Response.Write "&nbsp;&nbsp;<span class=""page_next""	onClick=""go_page('" & next_page & "','"&apage_str&"');"" title=""다음페이지"">다음</span>"
			Response.Write "<span class=""page_end""	onClick=""go_page('" & aTotPage   & "','"&apage_str&"');"" title=""마지막페이지"">▶</span>"
		Else
			Response.Write "&nbsp;&nbsp;<span class=""page_next""	onClick=""alert('마지막페이지입니다');"" title=""다음페이지"">다음</span>"
			Response.Write "<span class=""page_end""	onClick=""alert('마지막페이지입니다');"" title=""마지막페이지"">▶</span>"
		End If

	%>
		</td>
	</tr>
	<%
	End If
	'----------------------------------------------------------------------- Page Number E
End sub
Sub setCookieTodayView(sFid,sPrice,sImg,sproductshop_cd)
	'오늘 본 최근 5개의 상품 쿠키 입력
	cookieKey = "toDayView"
	count = Request.Cookies(cookieKey)("count")
	 if count = "" then count = 0

	 Pfid = sFid
	 pPrice =sPrice
	 pImg = sImg
	 pproductshop_cd = sproductshop_cd

	 '상품이 중복되면 넣지 않음.
	 checkReProd = "true"
	  for i = count to 1 step - 1
		  prod = Request.Cookies(cookieKey & i)("productshop_cd")
		  If prod = pproductshop_cd Then
			  checkReProd = "false"
		  End If
	  Next

		If checkReProd ="true" Then
			 for i = 1 to count - 1
			  Response.Cookies(cookieKey & i)("product") = Request.Cookies(cookieKey & (i + 1))("product")
			  Response.Cookies(cookieKey & i)("cost") = Request.Cookies(cookieKey & (i + 1))("cost")
			  Response.Cookies(cookieKey & i)("img") = Request.Cookies(cookieKey & (i + 1))("img")
			  Response.Cookies(cookieKey & i)("productshop_cd") = Request.Cookies(cookieKey & (i + 1))("productshop_cd")

			 next

			 count = count + 1
			 if 12 < count then count = 12
			 Response.Cookies(cookieKey)("count") = count
			 Response.Cookies(cookieKey & count)("product") = Pfid '상품별 변수값
			 Response.Cookies(cookieKey & count)("cost") = pPrice ' 상품별 판매가
			 Response.Cookies(cookieKey & count)("img") = pImg ' image
			 Response.Cookies(cookieKey & count)("productshop_cd") = pproductshop_cd ' product code
		End If

 End Sub

 Function getFindIdPwMailHtml(userpw,username)
	strHtml =  "			<html>"
	strHtml = strHtml & "	<table>"
	strHtml = strHtml & "	<Tr><td>"&username&"님</td><Td>리치피플  임시 비밀번호는 "&userpw&" 입니다. 접속 후 변경해주시기 바랍니다.</td></tr>"
	strHtml = strHtml & "	</table>"
	strHtml = strHtml & "	</html>"

	getFindIdPwMailHtml = strHtml
End Function

'=============================
'  use local SMTP service
'=============================
function SendMailLocal( cSubject, cMailFrom, cMailTo, cBody )
'제목,보낸사람,받는사람,내용
 dim oMessage, oConfig, oFields

 set oConfig = Server.CreateObject("CDO.configuration")
 set oFields = oConfig.Fields

 oFields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 1
 oFields.item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
 oFields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "localhost"
 oFields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory") = "C:\Inetpub\mailroot\Pickup"
 oFields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
 oFields.update

 set oMessage = Server.CreateObject("CDO.Message")
 set oMessage.Configuration = oConfig
 oMessage.BodyPart.Charset = "UTF-8"
 oMessage.from = cMailFrom
 oMessage.to = cMailTo
 oMessage.Subject = cSubject
 oMessage.HtmlBody = cBody
 oMessage.Send

 set oMessage = nothing
 set oFields = nothing
 set oConfig = nothing

 SendMailLocal = null
end Function


Function random_str(strlen)
'  Dim str, strlen, r, i, ds, serialCode '사용되는 변수를 선언

  str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" '랜덤으로 사용될 문자 또는 숫자

   'strlen = 5 '랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력

   Randomize '랜덤 초기화
   For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
    r = Int((36 - 1 + 1) * Rnd + 1)  ' 36은 str의 문자갯수
    serialCode = serialCode + Mid(str,r,1)
   Next
   random_str = serialCode
End Function

Const sBASE_64_CHARACTERS = _
           "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function Base64decode(ByVal asContents)
           Dim lsResult
           Dim lnPosition
           Dim lsGroup64, lsGroupBinary
           Dim Char1, Char2, Char3, Char4
           Dim Byte1, Byte2, Byte3
           if Len(asContents) Mod 4 > 0 _
          Then asContents = asContents & String(4 - (Len(asContents) Mod 4), " ")
           lsResult = ""

           For lnPosition = 1 To Len(asContents) Step 4
                   lsGroupBinary = ""
                   lsGroup64 = Mid(asContents, lnPosition, 4)
                   Char1 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 1, 1)) - 1
                   Char2 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 2, 1)) - 1
                   Char3 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 3, 1)) - 1
                   Char4 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 4, 1)) - 1
                   Byte1 = Chr(((Char2 And 48) \ 16) Or (Char1 * 4) And &HFF)
                   Byte2 = lsGroupBinary & Chr(((Char3 And 60) \ 4) Or (Char2 * 16) And &HFF)
                   Byte3 = Chr((((Char3 And 3) * 64) And &HFF) Or (Char4 And 63))
                   lsGroupBinary = Byte1 & Byte2 & Byte3

                   lsResult = lsResult + lsGroupBinary
           Next
Base64decode = lsResult
End function
' --------------------------------------
' ---------------------------------------
function Base64encode(ByVal asContents)
        Dim lnPosition
        Dim lsResult
        Dim Char1
        Dim Char2
        Dim Char3
        Dim Char4
        Dim Byte1
        Dim Byte2
        Dim Byte3
        Dim SaveBits1
        Dim SaveBits2
        Dim lsGroupBinary
        Dim lsGroup64

        if Len(asContents) Mod 3 > 0 Then _
        asContents = asContents & String(3 - (Len(asContents) Mod 3), " ")
        lsResult = ""

        For lnPosition = 1 To Len(asContents) Step 3
               lsGroup64 = ""
               lsGroupBinary = Mid(asContents, lnPosition, 3)

               Byte1 = Asc(Mid(lsGroupBinary, 1, 1)): SaveBits1 = Byte1 And 3
               Byte2 = Asc(Mid(lsGroupBinary, 2, 1)): SaveBits2 = Byte2 And 15
               Byte3 = Asc(Mid(lsGroupBinary, 3, 1))

               Char1 = Mid(sBASE_64_CHARACTERS, ((Byte1 And 252) \ 4) + 1, 1)
               Char2 = Mid(sBASE_64_CHARACTERS, (((Byte2 And 240) \ 16) Or _
               (SaveBits1 * 16) And &HFF) + 1, 1)
               Char3 = Mid(sBASE_64_CHARACTERS, (((Byte3 And 192) \ 64) Or _
               (SaveBits2 * 4) And &HFF) + 1, 1)
               Char4 = Mid(sBASE_64_CHARACTERS, (Byte3 And 63) + 1, 1)
               lsGroup64 = Char1 & Char2 & Char3 & Char4

               lsResult = lsResult + lsGroup64
         Next

         Base64encode = lsResult
End function

Function IsHangul(str)
    patrn = "[^가-힣]"
    Dim regEx, match, matches

    SET regEx = New RegExp

    regEx.Pattern = patrn            ' 패턴을 설정합니다.
    regEx.IgnoreCase = True      ' 대/소문자를 구분하지 않도록 합니다.
    regEx.Global = True             ' 전체 문자열을 검색하도록 설정합니다.


    SET Matches = regEx.Execute(str)

    if 0 < Matches.count then
        IsHangul = false
    Else
        IsHangul = true
    end if

End Function

Function fn_name_masking(fVAL)
	n = Len(fVAL)
	If n > 0 Then
		If IsHangul(fVAL) = true Then
			rtn_str = Left(fVAL, 1)
			For i = 1 To n-2
				rtn_str = rtn_str & "*"
			Next
			If n-2 < 1 Then
				rtn_str = rtn_str & "*"
			Else
				rtn_str = rtn_str & Right(fVAL, 1)
			End If
		ElseIf n > 7 Then
			f = InStr(fVAL, " ")
			If f > 0 Then
				rtn_str = Left(fVAL, f-1)
			Else
				rtn_str = Left(fVAL, 3)
			End If

			For i = Len(rtn_str) To n-4
				rtn_str = rtn_str & "*"
			Next
			rtn_str = rtn_str & Right(fVAL, 3)
		Else
			rtn_str = Left(fVAL, 1)
			For i = 2 To n-1
				rtn_str = rtn_str & "*"
			Next
			rtn_str = rtn_str & Right(fVAL, 1)
		End If
	Else
		rtn_str = fVAL
	End If
	fn_name_masking = rtn_str
End Function

Function fnDiscount(orgAmt, discount)
	dis = CInt(discount) / 100
	disAmt = CCur(orgAmt) * (1 - dis)
	fnDiscount = disAmt
End Function
%>