class RankingsController < ApplicationController
  before_action :logged_in_user
  def index
    @rankings = []

    User.all.each do |user|
      completed_quizzes = user.quizzes.where(status: :completed)
      next if completed_quizzes.empty?
        
      quiz_ids = completed_quizzes.pluck(:id)
      total_questions = QuizItem.where(quiz_id: quiz_ids).count
      total_correct = QuizItem.where(quiz_id: quiz_ids, is_correct: true).count

      accuracy = total_questions > 0 ? ((total_correct.to_f / total_questions) * 100).round : 0

      @rankings << { user: user, total_questions: total_questions, total_correct: total_correct, accuracy: accuracy }
    end

    @rankings.sort_by! { |r| [-r[:accuracy], -r[:total_questions]] }

    @current_user_ranking = nil
    @rankings.each_with_index do |ranking, index|
      ranking[:rank] = index + 1
      if ranking[:user].id == current_user.id
        @current_user_ranking = ranking
      end
    end
  end
end
