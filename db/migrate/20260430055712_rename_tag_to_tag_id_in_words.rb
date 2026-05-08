class RenameTagToTagIdInWords < ActiveRecord::Migration[8.1]
  def change
    rename_column :words, :tag, :tag_id
  end
end
