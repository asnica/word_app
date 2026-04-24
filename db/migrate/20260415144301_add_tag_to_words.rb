class AddTagToWords < ActiveRecord::Migration[8.1]
  def change
    add_column :words, :tag_id, :integer
  end
end
