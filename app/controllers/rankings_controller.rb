class RankingsController < ApplicationController
  before_action :logged_in_user

  UserStub = Struct.new(:id, :name)

  def index
    current_user_id = current_user&.id

    status_value = Quiz.statuses[:completed] rescue "completed"

    sql = <<-SQL
      WITH ranked_rankings AS (
        SELECT
          users.id AS user_id,
          users.name AS user_name,
          COUNT(quiz_items.id) AS total_questions,
          COUNT(CASE WHEN quiz_items.is_correct = true THEN 1 END) AS total_correct,
          ROUND(COUNT(CASE WHEN quiz_items.is_correct = true THEN 1 END) * 100.0 / COUNT(quiz_items.id), 1) AS accuracy,
          RANK() OVER (
            ORDER BY
              (COUNT(CASE WHEN quiz_items.is_correct = true THEN 1 END) * 100.0 / COUNT(quiz_items.id)) DESC,
              COUNT(quiz_items.id) DESC
          ) AS rank_num
        FROM users
        INNER JOIN quizzes ON quizzes.user_id = users.id
        INNER JOIN quiz_items ON quiz_items.quiz_id = quizzes.id
        WHERE quizzes.status = :status
        GROUP BY users.id
      )
      SELECT * FROM ranked_rankings
      WHERE rank_num <= 6 OR user_id = :current_user_id
      ORDER BY rank_num ASC
    SQL

    sanitized_sql = ActiveRecord::Base.sanitize_sql([ sql, { status: status_value, current_user_id: current_user_id } ])
    raw_results = ActiveRecord::Base.connection.execute(sanitized_sql)

    top_6_rows = raw_results.select { |row| row["rank_num"].to_i <= 6 }
    @rankings = top_6_rows.map do |row|
      {
        rank: row["rank_num"].to_i,
        accuracy: row["accuracy"].to_f,
        user: UserStub.new(row["user_id"].to_i, row["user_name"])
      }
    end

    current_user_row = raw_results.find { |row| row["user_id"].to_i == current_user_id }
    if current_user_row
      @current_user_ranking = {
        rank: current_user_row["rank_num"].to_i,
        total_questions: current_user_row["total_questions"].to_i,
        total_correct: current_user_row["total_correct"].to_i,
        accuracy: current_user_row["accuracy"].to_f,
        user: current_user
      }
    else
      @current_user_ranking = nil
    end
  end
end
