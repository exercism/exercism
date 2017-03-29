angular.module('exercism', ['ui.bootstrap'])

$ ->
  if location.pathname != '/' && $('h1, h2, h3').length && document.title == 'exercism.io'
    document.title = "#{$($('h1, h2, h3').get(0)).text()} - exercism.io"

  $('.submission-prompt').each (i, promptContainer) ->
    new SubmissionPrompt(promptContainer)

  $('.history_tab').each (i, historyTab) ->
    new CommentHistoryTab(historyTab)

  $("[data-toggle=tooltip]").tooltip()

  $("[data-search=tags]").autoComplete
    minChars: 2,
    source: (term, response) ->
      $.getJSON '/tags', { q: term }, (data) ->
        response data
    onSelect: (e, term, item) ->
      $("[data-search=tags]").closest("form").submit()

  if location.pathname.match(/submissions/)
    initCommentMemory()

  clientOutdatedNotice = $('.close + .client-outdated')
  clientOutdatedNotice.prev('.close').click ->
    username = clientOutdatedNotice.data('username')
    $.ajax
      url: "/#{username}/clear_client_version_notice"
      method: 'post'
      dataType: 'json'
      error: (xhr) ->
        console.log("Failed to mark notice as cleared: #{xhr.responseText}")

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

class SubmissionPrompt
  constructor: (container) ->
    @container = $(container)
    @initializeUI()

  initializeUI: ->
    @container.find('.btn-answer-prompt').click ->
      $('#submission_comment').focus()
    @container.find('.btn-new-prompt').click => @showNewPrompt()
    @showNewPrompt()
    @container.removeClass('hidden') # Leave hidden when JS not enabled

  showNewPrompt: ->
    target = @container.find('.prompt-text')
    fadeDuration = 50
    target.fadeOut fadeDuration, =>
      existing = target.text()
      replacement = @randomPrompt()
      while replacement == existing
        replacement = @randomPrompt()
      target.text replacement
      target.fadeIn fadeDuration

  randomPrompt: ->
    _.sample(@prompts)

  prompts: [
    "Are there any complicated bits that deserve to be named/abstracted using a function or variable?"
    "Are there any edge cases or unexpected inputs that aren't handled?"
    "Are there any intermediate variables or functions that could be extracted to give a name to some concept, making the code easier to scan and understand its intent?"
    "Could and should this code be simplified at all? What would you suggest?"
    "Could this code be reorganized in a way that would increase its testability, beyond what is required for the given tests?"
    "Did this solution use an appropriate amount of abstraction? What changes might make the code easier to understand?"
    "Do you have any naming suggestions that could better express intent?"
    "Do you understand why the author made the design choices that were made? In what situations might you want or not want to use this approach?"
    "How reusable is this code, such that you could use parts of it in new and unexpected contexts?"
    "How well might this code withstand future changes in requirements? Will the effort required to change it likely be proportional to the benefit of the change?"
    "Is there another approach that could yield better results?"
    "Is there anything in this submission that you don't understand or have questions about?"
    "Is this code exemplary? Would you want to see more like it? What specifically would you like to see more or less of?"
    "Is this code well-organized? What might make it better, and why?"
    "Is this easy for you read and understand? What might make it easier?"
    "What aspects of this submission do you like and want to incorporate in your own code?"
    "What did you learn from this submission?"
    "What principles could the author learn and apply that would improve this solution?"
    "What trade-offs can you identify being made in this submission? When would this be a good choice, and when would you want to try something different?"
    "Where does this solution's formatting stray from community style guides? If any, do the variances matter?"
    "Will this solution be performant at scale? In what cases might efficient performance matter?"
    "Would you want to want to work in a codebase composed of code similar to this? What do you like and dislike about it?"
  ]

class CommentHistoryTab
  constructor: (historyTabElement) ->
    @historyTab = $(historyTabElement)
    @writeTabLink = @historyTab.siblings('.write_tab').find('a')
    @writeTabTextarea = @historyTab.closest('.tabbable').find('textarea.comment')
    @historyItems = @historyTab.closest('.tabbable').find('.history_item')
    @initializeUI()

  initializeUI: ->
    @historyItems.click @selectItemCallback
    @historyTab.removeClass('hidden') # Leave hidden when JS not enabled

  selectItemCallback: (event) =>
    event.preventDefault()
    historyItem = $(event.target).closest('.history_item')
    historicalComment = historyItem.text()
    @appendText(historicalComment)
    @refreshPreviewContent()
    @activateWriteTab()

  appendText: (newText) ->
    existingText = @writeTabTextarea.val().trim()
    replacementText = ''
    replacementText += existingText + "\n\n---\n\n" unless _.isEmpty(existingText)
    replacementText += newText.trim()
    @writeTabTextarea.val replacementText

  refreshPreviewContent: ->
    @writeTabTextarea.trigger 'input'

  activateWriteTab: ->
    @writeTabLink.trigger 'click'
    @writeTabTextarea.focus()
