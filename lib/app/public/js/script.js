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
    var codeDiv = $(this).parents(".code");
    codeDiv.removeClass("span6");
    codeDiv.addClass("span12");
    $(this).hide();
    $("a[data-action='shrink']",codeDiv).show();
  });

  $(".code a[data-action='shrink']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    codeDiv.removeClass("span12");
    codeDiv.addClass("span6");
    $(this).hide();
    $("a[data-action='enlarge']",codeDiv).show();
  });

  $("#code-timeline").on("click",function() {
    var revisionId = $(event.target).data("revision");
    $(event.target).toggleClass("selected");
    $('#revision-' + revisionId).toggle();
  });
});