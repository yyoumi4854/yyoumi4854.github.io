$(function(){
  // header start
  //메뉴 PC
  $("#gnb>ul>li").mouseover(function(){
    $("#gnb>ul>li").removeClass("on");
    $(this).addClass("on");
    $(this).children(".sub").stop().slideDown();
  });

  $(".sub").mouseleave(function(){
    $(this).stop().slideUp();
  });

  $("#gnb").mouseleave(function(){
    $(".sub").stop().slideUp();
  });

  // 메뉴 버튼
  $(".gnb_btn").click(function(){
    $(this).toggleClass("open");
    if ($(this).hasClass("open")) {
      $("gnb_btn").show();
      $("#gnb_m").animate({"left":"0"},500);
      //열기
    }else {
      $("gnb_btn").hide();
      $("#gnb_m").animate({"left":"-50%"},300);
      //닫기
    }
  });

  //메뉴 모바일
  $("#gnb_m>ul>li>a").click(function(e){
    e.preventDefault();
    $("#gnb_m>ul>li>.dep2").stop().slideUp();
    $("#gnb_m>ul>li>a").removeClass("on");
    if(!$(this).siblings(".dep2").is(":visible")){
        $(this).siblings(".dep2").stop().slideDown();
        $(this).addClass("on");
    }
  });
  // header end

  // footer start
  $(".lang>a").click(function(e){
    e.preventDefault();
    $(this).next(".lang_select").slideToggle();
  });
  // footer end
});

// 타겟
// $(function(){
//   $("#gnb ul li").mouseover(function(){
//     var wid = $(this).width();
//     var target = $(this).parent().next(".target");
//
//     var po = $(this).offset();
//     console.log(po);
//
//     $(target).css({"width":wid, "margin-left":po.left});
//   });
// });
