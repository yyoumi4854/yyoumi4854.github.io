$(document).ready(function() {

	getList('');

	$(".setNew").click(function() {
		getList($(this).text());
	});

	var center_pos = parseInt(document.getElementById("map_contents").scrollWidth / 2) - 360;
	$("body").scrollLeft(center_pos);
	window.scrollTo(center_pos,0);
});

/*
function setNew(obj) {
	parent.document.getElementById('t_id').value = obj.innerText;
	getList(obj.innerText);
}
*/
function setNew(obj) {

	parent.document.getElementById('t_id').value = obj.innerText;
	var new_id	= obj.innerText;
	var new_lv	= $("#t_lv").val();
	var new_map	= $("#map_type").val();
	var new_url = "./map_body.html?t_id=" + new_id + "&t_lv=" + new_lv + "&t_map=" + new_map;
	
	location.href = new_url;
}

function go_signup(fTYPE, fUSERID) {
	top.parent.location.href = '/myoffice/profile/signup.html?kind=' + fTYPE + '&id=' + fUSERID;
}


function getList(fID) {

//	$("#loader").fadeIn();

	$("#org").remove();
	$("#chart").remove();

	var t_map = $("#map_type").val();
	var fLV = $("#t_lv").val();
	if (fID == "") fID = $("#t_id").val();

	$.ajax({
		type: "GET"
		,url: "./map_engine.html"
		,data: "t_map=" + t_map + "&t_id=" + fID + "&t_lv=" + fLV
		,async: false
		,dataType: "json"
		,cache: false
		,success: response_json
		,beforeSend: function() { 	$("#map_contents").fadeOut('fast'); $("#loader").fadeIn(); }
		,complete: function() { $("#loader").fadeOut(); }
	});

//	$("#loader").fadeOut();
}

function response_json(json) {

	$("#map_contents").append("<ul id=\"org\" style=\"display:none\"></ul>");
	$("#map_contents").append("<div id=\"chart\" class=\"orgChart\"></div>");

	var ArrData = json.dataList;
	var ArrCount= ArrData.length;

	$.each(ArrData, function(key) {
		var	cnt		= ArrData[key].cnt;
		var level	= ArrData[key].level;
		var userid	= ArrData[key].userid;	var cur_id = userid + "-1";
		var username= ArrData[key].username;
		var login_id= ArrData[key].login_id;
		var parent	= ArrData[key].parent;
		var rank	= ArrData[key].rank;
		var reg_date= ArrData[key].reg_date;
		var idColor	= ArrData[key].idColor;
		var prefix	= ArrData[key].prefix;
		var center_name= ArrData[key].center_name;
		var flag	= ArrData[key].flag;

		if (cnt == "1")	{
			var top_pos = " id=\"top_point\" ";
			$("#t_id").val(userid);
		} else {
			var top_pos = "";
		}

		var country = "<img src=\"/myoffice/downline/bizmap/img/flag/" + flag + "\" style=\"width:15px; margin-right:2px; vertical-align:middle;\">" + center_name;
//		var signup = "<span style=\"cursor:pointer;vertical-align:top;\" onClick=\"location.href=./signup.html?type='" + $("#map_type").val() + "&id=" + userid + "';\"><img src=\"./img/icon_signup.png\"></span>";

		var signup = "<span style=\"cursor:pointer;\" onClick=\"go_signup('" + $("#map_type").val() + "','" + login_id + "');\"><img src=\"./img/icon_signup.png\"></span>";

		var inner	= "";
		inner += "<div" + top_pos + ">";
		inner += "<dl>";
		inner += "	<dt style=\"" + idColor + "\">" + prefix + "<span onClick=\"setNew(this)\" style=\"cursor:pointer;\">" + login_id + "</span>" + signup + "</dt>";
		inner += "	<dd style=\"text-align:center; border-bottom:1px dotted #bbbbbb; padding-bottom:4px;\">" + country + "</dd>";
		inner += "	<dd style=\"text-align:center; border-bottom:1px dotted #bbbbbb; padding:2px 0;\">" + username + "</dd>";
		inner += "	<dd style=\"text-align:center; border-bottom:1px dotted #bbbbbb; padding:2px 0;\">" + rank + "</dd>";
		inner += "	<dd style=\"text-align:center; padding:2px 0; color:#868686;\">" + reg_date + "</dd>";
		inner += "</dl>";
		inner += "</div>";

		$("#"+parent).append(
			$("<li/>", {id: cur_id,html: inner})
		);

		$("#"+cur_id).append(
			$("<ul/>", {id: userid})
		);
	});

	$("#org").jOrgChart({
		chartElement : '#chart',
		dragAndDrop  : false
	});

	$("#map_contents").fadeIn(1000);

	var sc_width	= document.getElementById("map_contents").scrollWidth;
	var sc_height	= document.body.offsetHeight;
	var center_w	= parseInt(sc_width / 2 - 250);

	$('body').css('width',sc_width + "px");

	$("#top_panel").css("width",sc_width + "px");
}

function reset() {
	$("#t_id").val($("#init_id").val());
	$("#t_lv").val($("#init_lv").val());
	getList($("#t_id").val(), $("#t_lv").val());
}