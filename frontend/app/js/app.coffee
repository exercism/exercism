angular.module('exercism', ['ui.bootstrap'])

$ ->
  $('.member_delete').on 'click', ->
    username = $(@).data('username')
    slug = $(@).data('team')

    if confirm("Are you sure you want to dismiss #{username}")
      dismissTeamMember(username, slug)

  $('#edit_team').on 'click', (event) ->
    event.preventDefault()
    toggleTeamEdit()


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

dismissTeamMember = (username, slug) ->
  href = "/teams/#{slug}/members/#{username}"
  form = $('<form method="post" action="' + href + '"></form>')
  method_input = '<input name="_method" value="delete" type="hidden"/>';

  form.hide().append(method_input).appendTo('body');
  form.submit();