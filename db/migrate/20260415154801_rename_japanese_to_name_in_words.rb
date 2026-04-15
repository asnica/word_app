class RenameJapaneseToNameInWords < ActiveRecord::Migration[8.1]
  def change
    rename_column :words, :japanese, :name
  end
end
