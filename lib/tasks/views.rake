namespace :views do
  desc "delete all the views below the watermarks"
  task sweep: [:connection] do
    require 'exercism/view'

    View.delete_below_watermarks
    View.delete_obsolete
  end
end
