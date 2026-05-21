class QuizzesController < ApplicationController
  def index
    @quizzes = current_user.quizzes.order(created_at: :desc).page(params[:page]).per(9)
  end

  def create
    @quiz = Quiz.generate_quiz(current_user)
    redirect_to quiz_path(@quiz)
  end

  def show
    @quiz = current_user.quizzes.find(params[:id])
    if params[:position].present?
      @quiz.update(current_question_index: params[:position].to_i)
    end
    @quiz_item = @quiz.quiz_items.find_by(position: @quiz.current_question_index)

    if @quiz_item.nil?
      redirect_to review_quiz_path(@quiz) and return
    end
  end

  def answer
    @quiz = current_user.quizzes.find(params[:id])
    @quiz_item = @quiz.quiz_items.find_by(position: @quiz.current_question_index)

    is_correct = (params[:answer] == @quiz_item.word.meaning)
    @quiz_item.update(user_choice: params[:answer], is_correct: is_correct)

    @quiz.increment!(:current_question_index)

    if @quiz.current_question_index < @quiz.quiz_items.count
      redirect_to quiz_path(@quiz), status: :see_other
    else
      redirect_to review_quiz_path(@quiz), status: :see_other
    end
  end

  def previous
    @quiz = current_user.quizzes.find(params[:id])
    if @quiz.current_question_index > 0
      @quiz.decrement!(:current_question_index)
    end
    redirect_to quiz_path(@quiz), status: :see_other
  end

  def restart
    @old_quiz = current_user.quizzes.find(params[:id])
    @new_quiz = @old_quiz.restart_new_attempt
    redirect_to quiz_path(@new_quiz), status: :see_other, notice: "同じ問題で再挑戦します！"
  end

  def review
    @quiz = current_user.quizzes.find(params[:id])
    @quiz_items = @quiz.quiz_items.order(:position)
  end

  def result
    @quiz = current_user.quizzes.find(params[:id])
    @quiz.completed!
    @quiz_items = @quiz.quiz_items.order(:position)
    @score = @quiz_items.where(is_correct: true).count
    @quiz.update(total_score: @score)
  end
end