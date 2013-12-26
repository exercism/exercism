/* ==========================================================================
   exercism.io Theme custom application scripts
   ========================================================================== */

$(document).ready(function() {

  //Carousel
  $(".carousel").carousel();
  
  //Expand Code column
  $("#expand-code").on("click", function(){
    var $contentFirst = $("#content-first"),
		$sidebarSecond = $("#sidebar-second");
	if($contentFirst.hasClass("col-md-8")){
      $contentFirst.removeClass("col-md-8").addClass("col-md-12");
	  $sidebarSecond.removeClass("col-md-4").addClass("col-md-12");
	}else{
	  $contentFirst.removeClass("col-md-12").addClass("col-md-8");
	  $sidebarSecond.removeClass("col-md-12").addClass("col-md-4");
	}
  });
  
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
  
});