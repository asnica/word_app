class CreateWords < ActiveRecord::Migration[8.1]
  def change
    create_table :words do |t|
      t.string :japanese
      t.string :meaning
      t.text :note
      t.string :tag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
