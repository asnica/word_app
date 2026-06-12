class AddWordMeaningToQuizItems < ActiveRecord::Migration[8.1]
  def change
    add_column :quiz_items, :word_meaning, :string
  end
end
