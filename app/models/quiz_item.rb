class QuizItem < ApplicationRecord
  belongs_to :quiz
  belongs_to :word

  def choices
    correct_answer = word.meaning
    distractors = Word.where.not(id: word.id).order("RANDOM()").limit(2).pluck(:meaning)
    (distractors + [correct_answer]).shuffle
  end
end
