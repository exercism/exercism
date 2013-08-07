$(function() {
  var notification = new exercism.models.Notification(),
      notificationList = new exercism.collections.NotificationList({
    model: notification
  });
  $('.dropdown-toggle').dropdown();
  exercism.models.selectFilter = new exercism.models.SelectFilter();
  exercism.views.selectFilter = new exercism.views.SelectFilter({ model: exercism.models.selectFilter });
  exercism.routers.application = new exercism.routers.Application();
  exercism.collections.notificationsList = new exercism.collections.NotificationList({
    model: notification
  });
  exercism.views.toggleNotifications = new exercism.views.ToggleNotifications({
    el: $("#toggle-notifications"),
    collection: notificationList
  });
  Backbone.history.start();
});

//TODO move all variable declaration to the tops of functions.
$(function() {
  $(".pending-submission").each(function(index,element) {
    var elem = $(element);

    var language = elem.data('language');
    $(".language",elem).tooltip({ title: language });

    var nitCount = elem.data('nits');
    $(".nits",elem).tooltip({ title: nitCount + " Nits" });

    var argumentCount = elem.data('arguments');
    $(".arguments",elem).tooltip({ title: argumentCount + " Responses" });

    var versionCount = elem.data('versions');
    $(".versions",elem).tooltip({ title: "Iteration " + versionCount });
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

  $("#code-timeline").on("click",function(event) {
    var revisionId = $(event.target).data("revision");
    $(event.target).toggleClass("selected");
    $('#revision-' + revisionId).toggle();
  });

  $('form input[type=submit], form button[type=submit]').on('click', function() {
    var $this = $(this);
    window.setTimeout(function() { $this.attr('disabled', true); }, 1);
  });
  $('.work-slug').popover({
    trigger: 'hover',
    placement: 'right',
    html: true,
    delay: {
      show: 600,
      hide: 100
    },
    content: 'use the command <code>exercism fetch</code> to add this assignment to your exercism directory'
  });
});
