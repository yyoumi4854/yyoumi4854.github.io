$(function(){
  // swiper main_slide
  var swiper1 = new Swiper('.main_slide', {
    slidesPerView: 1,
    speed: 800,
    loop: true,
    autoplay: {
      delay: 4000,
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    }
  });

  // swiper best_slide
  var con1Swiper = new Swiper('.best_slide', {
    slidesPerView: 4,
    spaceBetween: 40,
    slidesPerGroup: 1,
    loop: true,
    loopFillGroupWithBlank: true,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    breakpoints: {
      767: {
        slidesPerView: 1,
        spaceBetween: 40,
      },
      1250 : {
        slidesPerView: 2,
        spaceBetween: 40,
      },
      1399 : {
        slidesPerView: 3,
        spaceBetween: 32,
      }
    }
  });

  //products
  $(".tab_menu li").click(function(e){
    e.preventDefault();
    var tc1 = $(this).children().attr("data-tab");
    var tc2 = "#" + tc1;
    $(".tab_con").hide();
    $(tc2).show();
    $(".tab_menu li").removeClass("on");
    $(this).addClass("on");
    console.log(tc1);
    console.log(tc2);
  });

  //swiper products
  var mainSwiper = new Swiper('.products_slide1', {
    slidesPerView: 1,
    speed: 800,
    loop: true, //무한루프 계속 재생가능
    //자동 재생
    autoplay: {
      delay: 4000,//3초동안 기다리고 넘기기
    },
    // 페이지표시
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
  });
  // Swiper 일시정지, 재생
  $(".products_slide1 .swiper-pagination").append('<a href="#" class="auto_btn"></a>');
  $(".auto_btn").click(function(e){
    e.preventDefault();
    $(this).toggleClass("on");
    if ($(this).hasClass("on")) {
      //일시정지
      mainSwiper.autoplay.stop();
    }else {
      //재생
      mainSwiper.autoplay.start();
    }
  });

  //video 유튜브
  $("#video a").click(function(e){
    e.preventDefault();
    $(".bg").fadeIn();
    $(".youtube").fadeIn();
    $("#video1 .bg").css({"visibility":"visible"});
  });

  $(".youtube a").click(function(e){
    e.preventDefault();
    $(".bg").fadeOut();
    $(".youtube").fadeOut();
    $("#video1 .bg").css({"visibility":"hidden"});
  });

  fnListJson(1);
});

function fnListJson( _pageNo, _kind){
  var _pageSize	= 8;
  var _perArea	= 5;
  var _totalPages = 0;
  var $tgList = $("#bestSellerList");
  var url = "/myoffice/json_data/list_product_json.html";
  var data = {
      page	 : _pageNo-1,
      pageSize : _pageSize,
      isActive : '1101',
      cate_cd1 : ''
    };

  $tgList.loading('start');
  $tgList.empty();
  $(".empty").hide();

  
  $.post(url, data, function(jsonData) {
      if (typeof jsonData !== 'object') {
        jsonData = JSON.parse(jsonData);
      }
      var addHtml = "";
      var bbsList = jsonData.list;
      var bbsPage = jsonData.page;

      _totalPages = bbsPage.totalElements;

        // echoNull2Blank(value.thum_img)
      $.each(bbsList, function(index, value){
        addHtml += '<li class="swiper-slide">';
        addHtml += '  <div class="list">';
        addHtml += '    <a href="/product/product.html?product_cd=' + echoNull2Blank(value.product_cd) + '">';
        addHtml += '      <div class="best_pro">';
        addHtml += '        <img src="' + echoNull2Blank(value.img_l) + '" alt="">';
        addHtml += '      </div>';
        addHtml += '      <div class="txt_wrap">';
        addHtml += '        <p>Belovps Sparkling Premium Soap</p>';
        addHtml += '        <p>' + numeral(value.amt).format('$0,0.00') + '</p>';
        addHtml += '        <p>';
        addHtml += '          <span>';
        addHtml += '            <i class="fas fa-star"></i>';
        addHtml += '            <i class="fas fa-star"></i>';
        addHtml += '            <i class="fas fa-star"></i>';
        addHtml += '            <i class="fas fa-star"></i>';
        addHtml += '            <i class="fas fa-star-half-alt"></i>';
        addHtml += '          </span>';
        addHtml += '          <span>Review : 450</span>';
        addHtml += '        </p>';
        addHtml += '      </div>';
        addHtml += '    </a>';
        addHtml += '    <div class="pay_wrap">';
        addHtml += '      <a href="#" onclick="fnCart(\'' + echoNull2Blank(value.product_cd) + '\');"></a>';
        addHtml += '      <a href="#" onclick="fnOrder(\'' + echoNull2Blank(value.product_cd) + '\');"></a>';
        addHtml += '    </div>';
        addHtml += '  </div>';
        addHtml += '</li>';
      });

      $tgList.html(addHtml);
      if (_totalPages == 0) {
        $(".empty").show();
      }
      /**/
      // swiper best_slide
      fnBestSlide();
  }, 'json')
  .fail(function (jqXHR, textStatus, errorThrown) {
    alert('HTTP status code: ' + jqXHR.status + '\n' +
      'textStatus: ' + textStatus + '\n' +
      'errorThrown: ' + errorThrown);
    alert('HTTP message body (jqXHR.responseText): ' + '\n' + jqXHR.responseText);
  })
  .always(function(){
    $tgList.loading('stop');
  });
}

function fnBestSlide() {
  // swiper best_slide
  var con1Swiper = new Swiper('.best_slide', {
    slidesPerView: 4,
    spaceBetween: 40,
    slidesPerGroup: 1,
    loop: true,
    loopFillGroupWithBlank: true,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    breakpoints: {
      767: {
        slidesPerView: 1,
        spaceBetween: 40,
      },
      1250 : {
        slidesPerView: 2,
        spaceBetween: 40,
      },
      1399 : {
        slidesPerView: 3,
        spaceBetween: 32,
      }
    }
  });
}