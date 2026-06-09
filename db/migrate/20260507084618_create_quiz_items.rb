class CreateQuizItems < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_items do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true
      t.boolean :is_correct
      t.integer :position

      t.timestamps
    end
  end
end
