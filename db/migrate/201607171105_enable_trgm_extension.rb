class EnableTrgmExtension < ActiveRecord::Migration
  def change
    enable_extension "pg_trgm"
  end
end
