<%@ CodePage="65001" Language="vbscript"%>
<%
Response.charset = "utf-8"
Session.CodePage=65001

Response.Expires = -10000
Server.ScriptTimeOut = 3000

On Error Resume Next

Set theForm = Server.CreateObject("DEXT.FileUpload")
theForm.MaxFileLen	= 3200000

theForm.DefaultPath = Server.Mappath("\upload\bbs_image") & "\"

imgAlign = theForm("imgAlign")

Set theField	= theForm("upfile")(1)
userfile_name	= funWordChk(theField.FileName)
userfile_size	= theField.FileLen

If userfile_size >= 4000000 Then

	Response.Write "<script language='javascript'>"
	Response.Write "	alert('파일크기가 너무 큽니다. 3M 이하로 조절해주십시오.');"
	Response.Write "</script>"

Else

	file_id			= Year(date) & Right("0"&Month(date),2) & Right("0"&Day(date),2) & Right("0"&Hour(now),2) & Right("0"&Minute(now),2) & fn_random("N",5)
	align			= theForm("img_align")

	UploadPath		= server.mappath("\upload\bbs_image") & "\"

	mime			= Right(userfile_name, Len(userfile_name) - InStrRev(userfile_name,"."))
	file1			= file_id & "." & mime

	file1name		= file_id

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


		'theField.Save "\datafiles\"&file1

	filePath = theForm.DefaultPath & file1
	theField.SaveAs filePath

	path = "/upload/bbs_image/" & file1

	'		sql = "insert into bbs_file_tmp (tempCode, userfile, filesize) values('"&UCC_RandomID&"', '" & file1 & "','"&userfile_size&"')"
	'		call execute (sql)

	Set theForm = Nothing

	Response.Write "<script language='javascript'>"
	Response.Write "	parent.imginsert('" & path & "', '" & imgAlign & "');"
	Response.Write "	parent.Div_Close();"
	Response.Write "	this.close();"
	Response.Write "</script>"

End If


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
