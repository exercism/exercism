!function() {
  // $('[data-toggle=tooltip').tooltip();
  $('#feedback_guide').popover({
    content: $('#encourage').html(),
    html: true
  });
  $('#feedback_guide_alert .close').click(function(e) {
    e.preventDefault();
    $.cookie('feedback_guide_alert', 'closed', {path: '/'});
  });

  $('#current_submission').theiaStickySidebar({
    additionalMarginTop: 70
  });

  if ($.cookie('feedback_guide_alert') !== 'closed') {
    $('#feedback_guide_alert').removeClass('hidden');
  }

  $('.member_delete').on('click', function(e) {
    e.preventDefault();

    var username = $(this).data('username');
    var slug = $(this).data('team');

    var confirmText = 'Are you sure you want to remove '
    confirmText << username
    confirmText << '?'
    if (confirm(confirmText)) {
      dismissTeamMember(username, slug);
    }
  });

  $('#destroy_team').on('click', function(e) {
    e.preventDefault();

    var slug = $(this).data('team');

    var confirmText = 'Are you sure you want to delete '
    confirmText << slug
    confirmText << '?'
    if (confirm(confirmText)) {
      destroyTeam(slug)
    }
  });

  $('#edit_team').on('click', function(e) {
    e.preventDefault();
    toggleTeamEdit();

    if (_.any($('.comments'))) {
      emojify.setConfig({emoticons_enabled: false});
      emojify.run(document.getElementsByClassName('comments')[0]);
    }
  });

  function toggleTeamEdit() {
    var members_box = $('#add_members');
    var delete_buttons = $('.member_delete');

    if (members_box.hasClass('hidden')) {
      delete_buttons.removeClass('hidden');
      members_box.slideDown();
      members_box.removeClass('hidden');
    } else {
      members_box.slideUp(function() {
        delete_buttons.addClass('hidden');
        members_box.addClass('hidden');
      });
    }
  };

  function destroyTeam(slug) {
    var href = '/teams/' + slug;
    var form = $('<form method="post" action="' + href + '"></form>');
    var method_input = '<input name="_method" value="delete" type="hidden">';

    form.hide().append(method_input).appendTo('body');
    form.submit();
  };

  function dismissTeamMember(username, slug) {
    var href = '/teams/' + slug + '/members/' + username;
    var form = $('<form method="post" action="' + href + '"></form>');
    var method_input = '<input name="_method" value="delete" type="hidden">';

    form.hide().append(method_input).appendTo('body');
    form.submit();
  };

  (function(i, s, o, g, r, a, m) {
    i["GoogleAnalyticsObject"] = r;
    i[r] = i[r] || function() {
      (i[r].q = i[r].q || []).push(arguments);
    };
    i[r].l = 1 * new Date();
    a = s.createElement(o);
    m = s.getElementsByTagName(o)[0];
    a.async = 1;
    a.src = g;
    m.parentNode.insertBefore(a, m);
  })(window, document, "script", "//www.google-analytics.com/analytics.js", "ga");

  ga("create", "UA-47528450-1", "exercism.io");

  ga("send", "pageview");
}(this);
