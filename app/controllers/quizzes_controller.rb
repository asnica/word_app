class QuizzesController < ApplicationController
  def index
    @quizzes = current_user.quizzes.order(created_at: :desc)
  end

  def create
    @quiz = Quiz.generate_quiz(current_user)
    redirect_to quiz_path(@quiz)
  end

  def show
    @quiz = current_user.quizzes.find(params[:id])
    @quiz_item = @quiz.quiz_items.find_by(position: @quiz.current_question_index)

    if @quiz_item.nil?
      @quiz.completed!
      flash[:notice] = "お疲れ様でした！全ての問題を解きました。"
      redirect_to quizzes_path
    end
  end
end
