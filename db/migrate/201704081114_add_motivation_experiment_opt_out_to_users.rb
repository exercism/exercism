require 'exercism/user'

class AddMotivationExperimentOptOutToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :motivation_experiment_opt_out, :boolean, null: false, default: false
    discussing_users = %w(
      alebafa bernardoamc codingthat duckmole GustavoCaso harley IBwWG iHiD
      jonatas jtigger kotp kytrinyx nilbus robphoenix StudentOfJS tleen
    )
    User.where(username: discussing_users).update_all(motivation_experiment_opt_out: true)
  end

  def down
    remove_column :users, :motivation_experiment_opt_out
  end
end
