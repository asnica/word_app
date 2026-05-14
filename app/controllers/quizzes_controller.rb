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
      @quiz.completed! unless @quiz.completed?
      redirect_to quizzes_path, status: :see_other, notice: "単語数が不足しているため、問題集は終了しました。" and return
    end
  end

  def answer
    @quiz = current_user.quizzes.find(params[:id])
    @quiz_item = @quiz.quiz_items.find_by(position: @quiz.current_question_index)

    if params[:answer] == @quiz_item.word.meaning
      @quiz_item.update(is_correct: true)
      @quiz.increment!(:total_score)
    else
      @quiz_item.update(is_correct: false)
    end

    @quiz.increment!(:current_question_index)

    if @quiz.current_question_index < @quiz.quiz_items.count
      redirect_to quiz_path(@quiz), status: :see_other
    else
      @quiz.completed!
      redirect_to quizzes_path, status: :see_other, notice: "すべての問題を解き終えました！"
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
end