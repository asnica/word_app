class QuizItem < ApplicationRecord
  belongs_to :quiz
  belongs_to :word, -> { unscoped }, optional: true

  serialize :choice_list, coder: JSON

  def choices
    choice_list
  end
end
