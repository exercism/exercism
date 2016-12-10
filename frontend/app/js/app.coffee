angular.module('exercism', ['ui.bootstrap'])

$ ->
  if location.pathname != '/' && $('h1, h2, h3').length && document.title == 'exercism.io'
    document.title = "#{$($('h1, h2, h3').get(0)).text()} - exercism.io"

  $("[data-toggle=tooltip]").tooltip()

  $("[data-search=tags]").autoComplete
    minChars: 2,
    source: (term, response) ->
      $.getJSON '/tags', { q: term }, (data) ->
        response data
    onSelect: (e, term, item) ->
      $("[data-search=tags]").closest("form").submit();

  if location.pathname.match(/submissions/)
    initCommentMemory()

  $("#current_submission").theiaStickySidebar(additionalMarginTop: 70)

  $('.manager_delete').on 'click', ->
    username = $(@).data('username')
    slug = $(@).data('team')

    if confirm("Are you sure you want to remove #{username} as a team manager?")
      dismissTeamManager(username, slug)

  $('.member_delete').on 'click', ->
    username = $(@).data('username')
    slug = $(@).data('team')

    if confirm("Are you sure you want to remove #{username} as a member?")
      dismissTeamMember(username, slug)

  $('.invite_dismiss').on 'click', ->
    username = $(@).data('username')
    slug = $(@).data('team')

    if confirm("Are you sure you want to dismiss invitation to #{username}?")
      dismissInvitation(username, slug)

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

localStorageHasKey = (key) ->
  return localStorage.getItem(key) != null

loadCommentFromStorage = () ->
  $('#submission_comment').val(localStorage.getItem(location.pathname))

recordText = () ->
  comment = localStorage.getItem(location.pathname)
  $('#submission_comment').keyup (event) ->
    text = $(this).val()
    unless comment == text
      comment = text
      localStorage.setItem(location.pathname, text)

initCommentMemory = () ->
  if localStorageHasKey(location.pathname)
    loadCommentFromStorage()
  recordText()

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

dismissInvitation = (username, slug) ->
  href = "/teams/#{slug}/invitation/#{username}"
  form = $('<form method="post" action="' + href + '"></form>')
  method_input = '<input name="_method" value="delete" type="hidden"/>'

  form.hide().append(method_input).appendTo('body')
  form.submit()

dismissTeamManager = (username, slug) ->
  href = "/teams/#{slug}/managers"
  form = $('<form method="post" action="' + href + '"></form>')
  method_input = '<input name="_method" value="delete" type="hidden"/>'
  username_input = '<input name="username" type="hidden" value="#{username}" />'

  form.hide().append(method_input).appendTo('body')
  form.hide().append(username_input).appendTo('body')
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
