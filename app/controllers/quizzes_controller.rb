class QuizzesController < ApplicationController
  before_action :logged_in_user
  before_action :set_quiz, only: [:show, :answer, :previous, :restart, :review, :result, :complete]

  def index
    @quizzes = current_user.quizzes.order(created_at: :desc).page(params[:page]).per(9)
  end

  def create
    if Word.count < 10
      redirect_to quizzes_path, alert: "問題集を作成するには、最低10個の単語が必要です。単語を追加してください。" and return
    else
      @quiz = Quiz.generate_quiz(current_user)
      redirect_to quiz_path(@quiz)
    end
  end

  def show
    if params[:position].present?
      @quiz.update(current_question_index: params[:position].to_i)
    end
    @quiz_item = @quiz.quiz_items.find_by(position: @quiz.current_question_index)

    if @quiz_item.nil?
      redirect_to review_quiz_path(@quiz, return_to: params[:return_to]) and return
    end
  end

  def answer
    @quiz_item = @quiz.quiz_items.find_by(position: @quiz.current_question_index)

    is_correct = (params[:answer] == @quiz_item.word.meaning)
    @quiz_item.update(user_choice: params[:answer], is_correct: is_correct)

    @quiz.increment!(:current_question_index)

    if @quiz.current_question_index < @quiz.quiz_items.count
      redirect_to quiz_path(@quiz, return_to: params[:return_to]), status: :see_other
    else
      redirect_to review_quiz_path(@quiz, return_to: params[:return_to]), status: :see_other
    end
  end

  def previous
    if @quiz.current_question_index > 0
      @quiz.decrement!(:current_question_index)
    end
    redirect_to quiz_path(@quiz, return_to: params[:return_to]), status: :see_other
  end

  def restart
    @old_quiz = current_user.quizzes.find(params[:id])
    @new_quiz = @old_quiz.restart_new_attempt
    redirect_to quiz_path(@new_quiz), status: :see_other, notice: "同じ問題で再挑戦します！"
  end

  def complete
    @quiz_items = @quiz.quiz_items
    @score = @quiz_items.where(is_correct: true).count

    @quiz.completed!
    @quiz.update(total_score: @score)

    redirect_to result_quiz_path(@quiz), status: :see_other
  end

  def review
    @quiz_items = @quiz.quiz_items.order(:position)
  end

  def result
    @quiz_items = @quiz.quiz_items.order(:position)
    @score = @quiz_items.where(is_correct: true).count
  end

  private

  def set_quiz
    @quiz = current_user.quizzes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to quizzes_path, alert: "権限がないか、無効なアクセスです。"
  end
end