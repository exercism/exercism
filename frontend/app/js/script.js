window.exercism = {};

exercism.filter = function (filter, value) {
  $('.pending-submission').hide();
  $('div[data-' + filter + '=' + value + ']').show();
  $('a#all-' + filter).show();
};

exercism.unfilter = function (filter) {
  var label = $('button[data-filter=' + filter + ']').attr('data-label');
  $('button[data-filter=' + filter + ']>span').first().html(label);
  $('div[data-' + filter + ']').show();
  $('a#all-' + filter).hide();
};

exercism.filterClick = function () {
  var value = $(this).html().trim();
  var target = $(this).attr('data-target');
  var filter = $(target).attr('data-filter');
  $(target + '>span').first().html(value);
  if (value === "All") {
    exercism.unfilter(filter);
  } else {
    exercism.filter(filter, value);
  }
};

exercism.checkClick = function () {
  if ($(this).is(':checked')) {
    var filter = $(this).attr('data-filter');
    $('.pending-submission').hide();
    $('div[data-' + filter + '!=0]').show();

  } else {
    $('.pending-submission').show();
  }
};

$(function() {
  $('.dropdown-toggle').dropdown();
  $('a[data-action=set-filter]').click(exercism.filterClick);
  $('input[data-action=set-filter]').click(exercism.checkClick);
});

//TODO move all variable declaration to the tops of functions.
$(function() {
  $(".pending-submission").each(function(index,element) {
    var elem = $(element);

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

  $('form input[type=submit], form button[type=submit]').on('click', function() {
    var $this = $(this);
    window.setTimeout(function() { $this.attr('disabled', true); }, 1);
  });
});
