<%@ CodePage="65001" Language="vbscript"%>
<%
Response.charset = "utf-8"
Session.CodePage=65001

Response.Expires = -10000
Server.ScriptTimeOut = 3000

On Error Resume Next

Set theForm = Server.CreateObject("DEXT.FileUpload")
theForm.MaxFileLen	= 3200000
theForm.DefaultPath = Server.Mappath("\bbs\upload\bbs_image") & "\"

Set theField	= theForm("uploadInputBox")(1)
userfile_name	= funWordChk(theField.FileName)
userfile_size	= theField.FileLen

If userfile_size >= 4000000 Then
	fail_msg = "파일크기가 너무 큽니다. 3M 이하로 조절해주십시오."
Else

	callback_func = theForm("callback_func")

	file_id		= Year(date) & Right("0"&Month(date),2) & Right("0"&Day(date),2) & Right("0"&Hour(now),2) & Right("0"&Minute(now),2) & fn_random("N",5)
	UploadPath	= server.mappath("\bbs\upload\bbs_image") & "\"

	mime		= Right(userfile_name, Len(userfile_name) - InStrRev(userfile_name,"."))
	file1		= file_id & "." & mime

	file1name	= file_id

	Dim fso,fexist,filenameadd,count1
	Set fso = Server.CreateObject("Scripting.FileSysTemObject")
		fexist = true
			filenameadd1 = UploadPath & file1

			count1 = 0
			while fexist = true
				if (fso.FileExists(filenameadd1)) then
					count1 = count1 + 1
					file1 = file1name & "(" & count1 &")."& mime
					filenameadd1 = UploadPath & file1
				else
					fexist = false
				end if
			wend
	Set fso = Nothing

	filePath = theForm.DefaultPath & file1
	theField.SaveAs filePath

	attach_path	= "/bbs/upload/bbs_image/" & file1
	return_url	= "/bbs/NEditor/photo_uploader/popup/callback.html?callback_func=" & callback_func & "&bNewLine=true&sFileName=" & file1 & "&sFileURL=" & attach_path

End If

Set theForm = Nothing

Response.Redirect return_url

Function funWordChk(strDBValue)
	if isNull(strDBValue)=false and isEmpty(strDBValue)=false and strDBValue<>"" then
		strDBValue = replace(strDBValue, "&" , "&amp;")
		strDBValue = replace(strDBValue, "<", "&lt;")
		strDBValue = replace(strDBValue, ">", "&gt;")
		strDBValue = replace(strDBValue, "'", "&quot;")
	end if

	funWordChk = strDBValue
End Function

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
%>