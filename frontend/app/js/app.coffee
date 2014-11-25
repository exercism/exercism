angular.module('exercism', ['ui.bootstrap'])

$ ->
  $("[data-toggle=tooltip]").tooltip();
  $("#feedback_guide").popover(content: $("#encourage").html(), html: true)
  $("#feedback_guide_alert .close").click (e) ->
    e.preventDefault()
    $.cookie 'feedback_guide_alert', 'closed', { path: '/' }
  console.log $.cookie()
  unless $.cookie('feedback_guide_alert') == 'closed'
    $("#feedback_guide_alert").removeClass("hidden")

  $('.member_delete').on 'click', ->
    username = $(@).data('username')
    slug = $(@).data('team')

    if confirm("Are you sure you want to dismiss #{username}")
      dismissTeamMember(username, slug)

  $('#destroy_team').on 'click', ->
    slug = $(@).data('team')

    if confirm("Are you sure you want to delete " + slug + "?")
      destroyTeam(slug)

  $('#edit_team').on 'click', (event) ->
    event.preventDefault()
    toggleTeamEdit()

  if _.any($('.comments'))
    emojify.setConfig(emoticons_enabled: false)
    emojify.run(document.getElementsByClassName("comments")[0])

toggleTeamEdit = ->
  members_box = $('#add_members')
  delete_buttons = $('.member_delete')
  if members_box.hasClass('hidden')
    delete_buttons.removeClass('hidden')
    members_box.slideDown()
    members_box.removeClass('hidden')
  else
    members_box.slideUp ->
      delete_buttons.addClass('hidden')
      members_box.addClass('hidden')

destroyTeam = (slug) ->
  href = "/teams/" + slug
  form = $('<form method="post" action="' + href + '"></form>')
  method_input = '<input name="_method" value="delete" type="hidden"/>'

  form.hide().append(method_input).appendTo('body')
  form.submit()


dismissTeamMember = (username, slug) ->
  href = "/teams/#{slug}/members/#{username}"
  form = $('<form method="post" action="' + href + '"></form>')
  method_input = '<input name="_method" value="delete" type="hidden"/>'

  form.hide().append(method_input).appendTo('body')
  form.submit()

((i, s, o, g, r, a, m) ->
  i["GoogleAnalyticsObject"] = r
  i[r] = i[r] or ->
    (i[r].q = i[r].q or []).push arguments
    return

  i[r].l = 1 * new Date()

  a = s.createElement(o)
  m = s.getElementsByTagName(o)[0]

  a.async = 1
  a.src = g
  m.parentNode.insertBefore a, m
  return
) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"
ga "create", "UA-47528450-1", "exercism.io"
ga "send", "pageview"