class EnableTrgmExtension < ActiveRecord::Migration[4.2]
  def change
    enable_extension "pg_trgm"
  end
end
