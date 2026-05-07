class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_items, dependent: :destroy
  has_many :words, through: :quiz_items

  enum :status, { ongoing: 0, completed: 1 }

  def self.generate_quiz(current_user)
    random_words = current_user.words.sample(10)

    quiz = current_user.quizzes.create(status: :ongoing, current_question_index: 0)

    random_words.each_with_index do |word, index|
      quiz.quiz_items.create(word: word, position: index)
    end

    quiz
  end

  def self.find_or_generate_ongoing(current_user)
    ongoing.where(user: current_user).last || generate_quiz(current_user)
  end

  def restart_new_attempt
    new_quiz = Quiz.create(user: self.user, status: :ongoing, current_question_index: 0)

    self.quiz_items.order(:position).each do |item|
      new_quiz.quiz_items.create(word: item.word, position: item.position)
    end

    new_quiz
  end
end
