require 'exercism/user'

class OptOutTheBot < ActiveRecord::Migration
  class User < ActiveRecord::Base; end

  def up
    User.where(username: 'rikki-').each do |rikki|
      rikki.update_attribute :motivation_experiment_opt_out, true
    end
  end

  def down
    User.where(username: 'rikki-').each do |rikki|
      rikki.update_attribute :motivation_experiment_opt_out, false
    end
  end
end
