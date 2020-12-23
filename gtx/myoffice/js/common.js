
// 주소창 자동 닫힘 
/*window.addEventListener("load", function(){ 
setTimeout(loaded, 100); 

}, false); 

function loaded(){ 
window.scrollTo(0, 1); 
} */

// <![CDATA[
try { 
	   window.addEventListener('load', function(){ 
			setTimeout(scrollTo, 0, 0, 1);  
	   }, false); 
  }  
catch(e) {} 

// 슬라이딩 메뉴
function toggle(id) {
    var el = document.getElementById(id);
    var img = document.getElementById("arrow");
    var box = el.getAttribute("class");
    if(box == "hide"){
        el.setAttribute("class", "show");
        delay(img, "/images/arrowright.png", 400);
    }
    else{
        el.setAttribute("class", "hide");
        delay(img, "/images/arrowleft.png", 400);
    }
}

function delay(elem, src, delayTime){
    window.setTimeout(function() {elem.setAttribute("src", src);}, delayTime);
}

function formatComma(num, pos) {
	if (!pos) pos = 0;  //소숫점 이하 자리수
	var re = /(-?\d+)(\d{3}[,.])/;

	var strNum = stripComma(num.toString());
	var strNum = stripSpace(num.toString());
	var arrNum = strNum.split(".");

	arrNum[0] += ".";

    while (re.test(arrNum[0])) {
        arrNum[0] = arrNum[0].replace(re, "$1,$2");
    }

	if (arrNum.length > 1) {
		if (arrNum[1].length > pos) {
			arrNum[1] = arrNum[1].substr(0, pos);
		}
		return arrNum.join("").toFixed(pos);
	}
	else {
		return arrNum[0].split(".")[0];
	}
}

/*--------------------------------------------------------------------
' Function    : stripComma(str)
' Description : 문자열 중 콤마를 제거
' Argument    : 
' Return      : 
' ------------------------------------------------------------------*/
function stripComma(str) {
    var re = /,/g;
    return str.replace(re, "");
}

function stripSpace(str) {
    var re = / /g;
    return str.replace(re, "");
}

function pop_view(fClose, fOpen, fDimmer,fTop, fLeft) {

	var scr_height	= $(document).height();
	var scr_width	= $(document).width();
	var open_width	= $("#" + fOpen).width();
	var open_height	= $("#" + fOpen).height();
	var open_left	= parseInt((scr_width - open_width) / 2);
	var open_top	= open_height;

	if (fTop != "")		{ open_top	= Number(fTop); }
	if (fLeft != "")	{ open_left	= Number(fLeft); }

	if (fDimmer == "T")	{
		$(window).scrollTop(0,0);
		$("#dimmer").width($(document).width());
		$("#dimmer").height($(document).height());
		$("#dimmer").show();
	}
	else
	{
		$("#dimmer").hide();
	}

	$("#" + fOpen).css("left", open_left+"px").css("top",open_top+"px");

	if (fClose != "")	$("#" + fClose).hide();
	if (fOpen != "") {
		$("#" + fOpen).fadeIn();
		$("#dimmer").width($(document).width());
		$("#dimmer").height($(document).height());
	}
}

function validateEmail(sEmail){
	var filter = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;

	if (filter.test(sEmail)) {
		return true;
	} else {
		return false;
	}
}

$(function(){
	jQuery.fn.validation = function(){
		var fn_chek = false;
		if(this[0].tagName && this[0].tagName.toUpperCase() == "FORM" ) {
			var obj = $(this).find(":input");
			$.each(obj, function(index, value){
				var field_check = $(value).attr("check");
				var field_type	= $(value).attr("check_type");
				var field_length= $(value).attr("check_length");
				var field_key	= $(value).attr("check_key");
				var	field_alert	= $(value).attr("title");
				var field_value	= $(value).val();
				if (field_check == "T") {
					if (value.type == "checkbox"){
						field_key = (field_key) ? Number(field_key) : 1;
						if ($("input:checkbox[name=" + value.name + "]:checked").length < field_key){
							alert(field_alert);
							$(value).focus();
							fn_chek = false;
							return false;
						}
					} else if (value.type == "radio"){
						if ($("input:radio[name=" + value.name + "]:checked").length < 1){
							alert(field_alert);
							$(value).focus();
							fn_chek = false;
							return false;
						}
					} else if (field_type == "length") {
						if (field_value.length <= Number(field_length))	{
							alert(field_alert);
							$(value).focus();
							fn_chek = false;
							return false;
						}
					} else if (field_type == "value") {
						if (field_value != field_key)
						{
							alert(field_alert);
							$(value).focus();
							fn_chek = false;
							return false;
						}
					}
				}
				fn_chek = true;
			});
			return fn_chek;
		}
	}

	jQuery.fn.serializeObject = function() {
		var obj = null;
		try {
			// this[0].tagName이 form tag일 경우
			if(this[0].tagName && this[0].tagName.toUpperCase() == "FORM" ) {
				var arr = this.serializeArray();
				if(arr){
					obj = {};
					jQuery.each(arr, function() {
						// obj의 key값은 arr의 name, obj의 value는 value값
						if (typeof obj[this.name] == 'undefined') {
							obj[this.name] = this.value;
						} else {
							obj[this.name] += "," + this.value;
						}
					});
				}
			}
		}catch(e) {
			alert(e.message);
		}finally  {}

		return obj;
	};
});

(function($) {
    $.fn.jqueryPager = function(options) {
        var defaults = {
            pageSize: 10,
            currentPage: 1,
            pageTotal: 0,
            pageBlock: 10,
            clickEvent: 'fnGoPage'
        };

        var subOption = $.extend(true, defaults, options);

        return this.each(function() {
            var currentPage = subOption.currentPage*1;
            var pageSize = subOption.pageSize*1;
            var pageBlock = subOption.pageBlock*1;
            var pageTotal = subOption.pageTotal*1;
            var clickEvent = subOption.clickEvent;

            if (!pageSize) pageSize = 10;
            if (!pageBlock) pageBlock = 10;

            var pageTotalCnt = Math.ceil(pageTotal/pageSize);
            var pageBlockCnt = Math.ceil(currentPage/pageBlock);
            var sPage, ePage;
            var html = '';

            if (pageBlockCnt > 1) {
                sPage = (pageBlockCnt-1)*pageBlock+1;
            } else {
                sPage = 1;
            }

            if ((pageBlockCnt*pageBlock) >= pageTotalCnt) {
                ePage = pageTotalCnt;
            } else {
                ePage = pageBlockCnt*pageBlock;
            }

            if (sPage > 1) {
                // html += '<li><a href="javascript:'+ clickEvent +'(1);" class="page_arrow"><img src="/img/common/board_first_arrow.png" alt="맨처음"></a></li>';
				// html += '<li><a href="javascript:'+ clickEvent +'(' + (sPage-pageBlock) + ');" class="page_arrow"><img src="/img/common/board_prev_arrow.png" alt="이전"></a></li>';
				html += '<a href="javascript:'+ clickEvent +'(' + (sPage-pageBlock) + ');" class="prev">prev</a>';
            }

            for (var i=sPage; i<=ePage; i++) {

	            html += '<span>';
                if (currentPage == i) {
                    html+= '<a href="javascript:;" class="active">' + i + '</a>';
                } else {
                    html+= '<a href="javascript:'+ clickEvent +'(' + i + ');">' + i + '</a>';
                }
	            html += '</span>';
            }


            if (ePage < pageTotalCnt) {
            //    html += '<li><a href="javascript:'+ clickEvent +'(' + (ePage+1) + ');" class="page_arrow"><img src="/img/common/board_next_arrow.png" alt="다음"></a></li>';
			//    html += '<li><a href="javascript:'+ clickEvent +'(' + pageTotalCnt + ');" class="page_arrow"><img src="/img/common/board_last_arrow.png" alt="마지막"></a></li>';
				html += '<a href="javascript:'+ clickEvent +'(' + (ePage+1) + ');" class="next">next</a>';
            }


            $(this).empty().html(html);
      });
    };
})(jQuery);

function echoNull2Blank(str) {
	if (str == null) return '';
	return str;
}