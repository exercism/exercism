/* ==========================================================================
   exercism.io Theme custom application scripts
   ========================================================================== */

$(document).ready(function() {

  //Carousel
  $(".carousel").carousel();
  
  //Expand Code column
 /* $("#expand-code").on("click", function(){
    var $contentFirst = $("#content-first"),
		$sidebarSecond = $("#sidebar-second");
	if($contentFirst.hasClass("col-md-8")){
      $contentFirst.removeClass("col-md-8").addClass("col-md-12");
	  $sidebarSecond.removeClass("col-md-4").addClass("col-md-12");
	}else{
	  $contentFirst.removeClass("col-md-12").addClass("col-md-8");
	  $sidebarSecond.removeClass("col-md-12").addClass("col-md-4");
	}
  });*/
  
  
  /*****Add js for middle div expend ****/
   $("#expand-code").on("click", function(){
    var $contentFirst = $("#content-first"),
		$sidebarSecond = $("#sidebar-second");
	if($contentFirst.hasClass("col-md-8")){
      $contentFirst.removeClass("col-md-8").addClass("col-md-12");
	  $sidebarSecond.removeClass("col-md-4").addClass("col-md-12");
	}
	else if($contentFirst.hasClass("col-md-7"))
	{
		$contentFirst.removeClass("col-md-7").removeClass("code_midd").addClass("col-md-12");
	  $sidebarSecond.removeClass("col-md-5").removeClass("my_code_right").addClass("col-md-12");
	}
	else{
	  $contentFirst.removeClass("col-md-12").addClass("col-md-7").addClass("code_midd");
	  $sidebarSecond.removeClass("col-md-12").addClass("col-md-5").addClass("my_code_right");
	}
  });
  
  /*****End js for middle div expend ****/
  
  /* Navigation tree */
  $("label.tree-toggler").click(function () {
    $(this).parent().children("ul.tree").slideToggle(300);
	var $parent = $(this).parents(".list-menu");
	if($parent.hasClass("open")){
	  $parent.removeClass("open");
	}else{
	  $parent.addClass("open");
	}
  });
  
  /* Toggle Add Team Form */
  $(".toggle-add-team").on("click", function(){
    $(this).parents("li").find(".form-add-team").slideToggle(300);
  });
  
  /* Toggle Section Content */
  $(".section-toggle .toggle").on("click", function(){
    $(this).parents(".section-toggle").find(".toggle-content").slideToggle(300);
    var operator = $(this).text() == "-" ? "+" : "-";
    $(this).text(operator);
  }); 
  
  /* Toggle Account Settings box */
  $(".toggle-account-settings").click(function () {
	var $page = $("#account-settings");
	$page.animate({width: 'toggle'});
  });
  
  
  /************More Results*********/
     
   
   $("#more_res").click(function () {
		$( "#view_sol ul" ).append( '<li> <div class="content_main_left"><div class="image_content"><img class="img-circle" src="images/photo.png"/></div><div class="text_image_content"><p><a href="">anagram</a><span class="tit"> objective-c</span></p> <p>JonanMoses (3) <span class="itelice">About 7 hours ago</span> </p></div><div class="clear"></div></div><div class="content_main_right"><div class="group1"><div class="box1">3 Iterations</div><div class="sprite-icon-code menu-icon"></div></div><div class="group2"><div class="box2">24 Nits</div><div class="sprite-icon-comment menu-icon"></div> <div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></li>' );
  });
  
  /************ End More results ********/
  
  });


 $(".toggle-account-settings1").click(function () {
	var $page = $("#account-settings1");
	$page.animate({width: 'toggle'});
  });

$(document).ready(function(){
	 $("#add-nitpick").hide();
  $("#show1").click(function(){
    $("#add-nitpick").toggle();
  });
});


$(document).ready(function(){
  $("#xclosee").click(function(){
    $("#Re-Open").show();
	$("#xclosee").hide();
	return false;
  });
  $("#Re-Open").click(function(){
    $("#xclosee").show();
	 $("#Re-Open").hide();
	return false;
  });
});