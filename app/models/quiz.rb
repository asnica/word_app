class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_items, dependent: :destroy
  has_many :words, through: :quiz_items

  enum :status, { ongoing: 0, completed: 1 }

  def self.generate_quiz(current_user)
    random_words = Word.order("RANDOM()").limit(10)

    quiz = current_user.quizzes.create(status: :ongoing, current_question_index: 0)

    random_words.each_with_index do |word, index|
      distractors = Word.where.not(id: word.id).order("RANDOM()").limit(2).pluck(:meaning)
      shuffled_array = (distractors + [word.meaning]).shuffle

      quiz.quiz_items.create(word: word, position: index, choice_list: shuffled_array, word_name: word.name, word_meaning: word.meaning, word_synonym: word.synonym)
    end

    quiz
  end

  def self.find_or_generate_ongoing(current_user)
    ongoing.where(user: current_user).last || generate_quiz(current_user)
  end

  def restart_new_attempt
    transaction do
      new_quiz = Quiz.create!(user: self.user, status: :ongoing, current_question_index: 0, total_score: 0)

      self.quiz_items.order(:position).each_with_index do |item, index|
        new_quiz.quiz_items.create!(
          word_id: item.word_id,
          position: index,
          choice_list: item.choice_list,
          word_name: item.word_name,
          word_meaning: item.word_meaning,
          word_synonym: item.word_synonym
          )
      end
      new_quiz
    end
  end
end