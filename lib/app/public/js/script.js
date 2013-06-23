$(function() {
  $(".pending-submission").each(function(index,element) {
    var elem = $(element);

    elem.hover(function() {
      $(this).addClass('hover');
    },function() {
      $(this).removeClass('hover');
    });

    elem.on("click",function() {
      var submissionURL = $(this).data('url');
      window.location = submissionURL;
    });

    var language = elem.data('language');
    $(".language",elem).tooltip({ title: language });

    var nitCount = elem.data('nits');
    $(".nits",elem).tooltip({ title: nitCount + " Nits" });

    var argumentCount = elem.data('arguments');
    $(".arguments",elem).tooltip({ title: argumentCount + " Responses" });

  });

  $(".code a[data-action='enlarge']").on("click",function() {
    $(".code").removeClass("span6");
    $(".code").addClass("span12");
    $(this).hide();
    $(".code a[data-action='shrink']").show();
  });

  $(".code a[data-action='shrink']").on("click",function() {
    $(".code").removeClass("span12");
    $(".code").addClass("span6");
    $(this).hide();
    $(".code a[data-action='enlarge']").show();
  });
});