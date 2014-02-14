$(document).ready(function() {

  $(".carousel").carousel();

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

  $("label.tree-toggler").click(function () {
    $(this).parent().children("ul.tree").slideToggle(300);
    var $parent = $(this).parents(".list-menu");
    if($parent.hasClass("open")){
      $parent.removeClass("open");
    }else{
      $parent.addClass("open");
    }
  });

  $(".toggle-add-team").on("click", function(){
    $(this).parents("li").find(".form-add-team").slideToggle(300);
  });

  $(".section-toggle .toggle").on("click", function(){
    $(this).parents(".section-toggle").find(".toggle-content").slideToggle(300);
    var operator = $(this).text() == "-" ? "+" : "-";
    $(this).text(operator);
  });

  $(".completed.exercises ul").each(function() {
    var ul = $(this)
    var lis = ul.children("li")
    if (lis.length > 5) {
      var div = ul.parent();
      var less = $("<a href='#'>- less</a>");
      var more = $("<a href='#'>+ more</a>");

      less.on("click", function(e) {
        lis.slice(5).hide();
        div.append(more);
        if (less.is("html *")) {
          less.detach();
        }
        e.preventDefault();
      });

      more.on("click", function(e) {
        lis.show();
        div.append(less);
        if (more.is("html *")) {
          more.detach();
        }
        e.preventDefault();
      });

      less.click();
    }
  })
});
