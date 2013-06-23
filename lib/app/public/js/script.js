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
});