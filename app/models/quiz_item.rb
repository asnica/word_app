class QuizItem < ApplicationRecord
  belongs_to :quiz
  belongs_to :word

  def choices
    choice_list.split(",")
  end
end
