class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.integer :current_question_index
      t.integer :total_score

      t.timestamps
    end
  end
end
