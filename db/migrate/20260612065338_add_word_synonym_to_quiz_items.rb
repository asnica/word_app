class AddWordSynonymToQuizItems < ActiveRecord::Migration[8.1]
  def change
    add_column :quiz_items, :word_synonym, :string
  end
end
