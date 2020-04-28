<%
Server.ScriptTimeOut = 30 * 60 '30분

Response.ContentType = "text/html;charset=utf-8"
Response.Expires = 0
Response.AddHeader "Pragma", "no-cache"
Response.AddHeader "Cache-Control", "no-store"

FileName	= Request.ServerVariables("HTTP_FILE_NAME")
FileNameExt = LCase(Mid(FileName, InstrRev(FileName, ".") + 1))

If Not (StrComp(FileNameExt,"bmp") = 0 Or StrComp(FileNameExt,"gif") = 0 Or StrComp(FileNameExt,"jpg") = 0  Or StrComp(FileNameExt,"jpeg") = 0  Or StrComp(FileNameExt,"png") = 0) Then
	Response.End
End IF

file_id		= Year(date) & Right("0"&Month(date),2) & Right("0"&Day(date),2) & Right("0"&Hour(now),2) & Right("0"&Minute(now),2) & fn_random("N",5)
UploadPath	= server.mappath("\bbs\upload\bbs_image") & "\"

new_file	= file_id & "." & FileNameExt
new_name	= file_id

Dim fso,fexist,filenameadd,count1
Set fso = Server.CreateObject("Scripting.FileSysTemObject")
	fexist = true
		filenameadd1 = UploadPath & new_file

		count1 = 0
		while fexist = true
			if (fso.FileExists(filenameadd1)) then
				count1		 = count1 + 1
				new_file	 = new_name & "(" & count1 &")."& FileNameExt
				filenameadd1 = UploadPath & new_file
			else
				fexist = false
			end if
		wend
Set fso = Nothing

temp		= Request.TotalBytes
BytesRead	= 0
PartSize	= 0

Set myStream = CreateObject("ADODB.Stream")

	myStream.Type = 1 ' binary
	myStream.Mode = 3
	myStream.Open

	Do While BytesRead < temp
		PartSize = 64*1024   '64KB

		If PartSize + BytesRead > temp Then
			PartSize = temp - BytesRead
		End if

		DataPart = Request.BinaryRead(PartSize)
		BytesRead = BytesRead + PartSize
		myStream.Write(DataPart)
	Loop

	'myStream.SaveToFile("D:\WWWROOT\YLS\bbs\upload\bbs_image\" & new_file)
	'myStream.SaveToFile("D:\WEB_Service\DEV2\bbs\upload\bbs_image\" & new_file)
	myStream.SaveToFile(Replace(Request.ServerVariables("PATH_TRANSLATED"),"\bbs\NEditor\photo_uploader\popup\file_uploader_html5.asp","") & "\bbs\upload\bbs_image\" & new_file)
	'myStream.SaveToFile(request.ServerVariables("APPL_PHYSICAL_PATH")&"bbs\upload\bbs_image\"& new_file)

	myStream.Close
	'APPL_PHYSICAL_PATH
	'request.ServerVariables("APPL_PHYSICAL_PATH")

Set myStream = Nothing

sFileInfo = ""
sFileInfo = sFileInfo & "&bNewLine=true"
sFileInfo = sFileInfo & "&sFileName=" & new_file
sFileInfo = sFileInfo & "&sFileURL=/bbs/upload/bbs_image/" & new_file

Response.Write sFileInfo
Response.End

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