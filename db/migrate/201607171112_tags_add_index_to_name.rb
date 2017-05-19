class TagsAddIndexToName < ActiveRecord::Migration[4.2]
  def up
    execute "CREATE INDEX index_tags_similarity_on_name ON tags USING gist (name gist_trgm_ops);"
  end

  def down
    execute "DROP INDEX name_similarity_idx;"
  end
end
