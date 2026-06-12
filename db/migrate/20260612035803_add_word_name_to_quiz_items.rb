class AddWordNameToQuizItems < ActiveRecord::Migration[8.1]
  def change
    add_column :quiz_items, :word_name, :string
  end
end
