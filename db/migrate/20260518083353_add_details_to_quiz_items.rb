class AddDetailsToQuizItems < ActiveRecord::Migration[8.1]
  def change
    add_column :quiz_items, :user_choice, :string
    add_column :quiz_items, :choice_list, :string
  end
end
