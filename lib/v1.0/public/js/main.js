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

  $(".completed.exercises").each(function() {
    var limit = 5;
    var div = $(this);
    var lis = div.children('ul').children('li');

    if (lis.length > limit) {
      var excess = lis.slice(limit);

      var toggle = function(target, replacement) {
        target.on("click", function(e) {
          excess.toggle();
          target.detach();
          div.append(replacement);
          e.preventDefault();
        });
      };

      var less = $("<a href='#'>- less</a>");
      var more = $("<a href='#'>+ more</a>");

      toggle(less, more);
      toggle(more, less);
      less.click();
    }
  })
});
