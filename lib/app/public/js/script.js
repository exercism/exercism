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

  function filterPending() {
    var selectedOptions = {};
    $('button[data-filter]').each(function() {
      var key = $(this).data('filter'),
          value = $(this).data('selected');
      selectedOptions[key] = value;

      if (value == "All") {
        $(this).find('span.filter-label').text($(this).data('label'));
        $('#all-' + key).hide();
      } else {
        $(this).find('span.filter-label').text(value);
        $('#all-' + key).show();
      }
    });

    $('.pending-submission').each(function() {
      var $submission = $(this);
      display = true;
      $.each(selectedOptions, function(key, value) {
        display = display && (value == "All" || $submission.data(key) == value);
      });
      $submission.toggle(display);
    });
  }

  $('a[data-action="set-filter"]').on("click", function(e) {
    e.preventDefault();
    var selectedOption = $(this).text().trim();
    var $target = $($(this).data('target'));
    $target.data('selected', selectedOption);
    filterPending();
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
