class AddDeletedFieldsToWords < ActiveRecord::Migration[8.1]
  def change
    add_column :words, :deleted, :integer, default: 0, null: false, comment: "削除フラグ(0=>未削除,1=>削除)"
    add_column :words, :deleted_at, :datetime, comment: "削除日時"

    add_index :words, :deleted
  end
end
