class AddSynonymToWords < ActiveRecord::Migration[8.1]
  def change
    add_column :words, :synonym, :string
  end
end
