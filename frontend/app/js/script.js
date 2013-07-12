window.exercism = {};

window.exercism.SelectFilter = Backbone.Model.extend({
  defaults: {
    user: $(".dropdown-toggle[data-filter=user]").attr("data-selected"),
    exercise: $(".dropdown-toggle[data-filter=exercise]").attr("data-selected"),
    language: $(".dropdown-toggle[data-filter=language]").attr("data-selected"),
    nits: $("input[type=checkbox][data-filter=nits]").attr("data-selected"),
    arguments: $("input[type=checkbox][data-filter=arguments]").attr("data-selected")
  },

  setCheck: function (attribute, value) {
    this.set(attribute, value ? "0" : "All" );
  }
});

exercism.filter = function (filter, value) {
  $('div[data-' + filter + '][' + 'data-' + filter + '!=' + value + ']').hide();
  $('a#all-' + filter).show();
};

exercism.showAll = function () {
  $('.pending-submission').show();
};

exercism.unfilter = function (filter) {
  var label = $('button[data-filter=' + filter + ']').attr('data-label');
  $('button[data-filter=' + filter + ']>span').first().html(label);
  $('div[data-' + filter + ']').show();
  $('a#all-' + filter).hide();
};

exercism.filters = function (element, index, list) {
  if (element === "All") {
    exercism.unfilter(element);
  } else {
    exercism.filter(index, element);
  }
};

exercism.renderFilters = function () {
  exercism.showAll();
  _.each(exercism.selectFilter.attributes, exercism.filters);
};

exercism.filterClick = function () {
  var value = $(this).html().trim();
  var target = $(this).attr('data-target');
  var filter = $(target).attr('data-filter');
  exercism.selectFilter.set(filter, value);
  $(target + '>span').first().html(value);
  exercism.renderFilters();
};

exercism.checkClick = function () {
    var filter = $(this).attr('data-filter');
    exercism.selectFilter.setCheck(filter, $(this).is(':checked'));
    exercism.renderFilters();
};

$(function() {
  $('.dropdown-toggle').dropdown();
  $('a[data-action=set-filter]').click(exercism.filterClick);
  $('input[data-action=set-filter]').click(exercism.checkClick);
  window.exercism.selectFilter = new exercism.SelectFilter();
  exercism.renderFilters();
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
