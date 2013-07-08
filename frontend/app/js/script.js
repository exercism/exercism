//TODO move all variable declaration to the tops of functions.
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

  //FIXME move filterPending into a namespaced app object to minimize global
  //pollution.
  function filterPending() {
    var selectedOptions = {};
    $('button[data-filter], input[data-filter]').each(function() {
      var key = $(this).data('filter'),
          value = $(this).data('selected');
      selectedOptions[key] = value;

      if (this.tagName === "BUTTON") {
        if (value === "All") {
          $(this).find('span.filter-label').text($(this).data('label'));
          $('#all-' + key).hide();
        } else {
          $(this).find('span.filter-label').text(value);
          $('#all-' + key).show();
        }
      }
    });

    $('.pending-submission').each(function() {
      var $submission = $(this);
      display = true;
      //FIXME Looping through selectedOptions while looping through each submission
      //FIXME Last minute toString(). This is brittle and will bite us.
      //TODO Use JavaScript looping functionality instead of $.each
      $.each(selectedOptions, function(key, value) {
        display = display && (value === "All" || $submission.data(key).toString() === value);
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

  $('input[data-action="set-filter"]').on("click", function(e) {
    var selectedOption = ($(this).is(":checked") ? "0" : "All");
    $(this).data('selected', selectedOption);
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

  $('form input[type=submit], form button[type=submit]').on('click', function() {
    var $this = $(this);
    window.setTimeout(function() { $this.attr('disabled', true); }, 1);
  });
});
