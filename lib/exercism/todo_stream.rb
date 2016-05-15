require 'will_paginate/array'

# TodoStream is an activity stream for todo list.
class TodoStream

  attr_reader :track_id, :page, :per_page

  def initialize(track_id, page=1)
    @track_id = track_id
    @page = page.to_i
    @per_page = 10
  end

  def todos
    @todos ||= X::Todo.track(track_id).todos
  end

  def pagination
    todos.paginate(page: page, per_page: per_page)
  end
end
