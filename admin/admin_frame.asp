<!--#include virtual="/myoffice/common/common.inc"-->
<html lang="ko">
<head>
	<title>▒ <%=session("company")%> 관리자페이지</title>
	<meta charset="utf-8">
</head>

<frameset cols="0,243,850,*"	frameborder="no"	border="0"	framespacing="0">

	<frame src="./blank.asp"		id="blFrame"	name="blFrame"		scrolling="no"		topmargin="0" noresize>
	<frame src="./admin_menu.asp"	id="leftFrame"	name="leftFrame"	scrolling="auto"	topmargin="0" noresize>

	<frameset rows="88,*"		frameborder="no"	border="0"	framespacing="0">
		<frame src="./admin_title.asp"					id="topFrame"	name="topFrame"		scrolling="no"		leftmargin="0"	topmargin="0" noresize>
		<frame src="/bbs/bbs_list.asp?bbs_kind=NOTICE"	id="RealFrame"	name="RealFrame"	scrolling="auto"	leftmargin="10"	topmargin="0" noresize>
	</frameset>

</frameset>

<noframes></noframes>

