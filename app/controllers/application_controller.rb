class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  # 現在ログイン中のユーザーオブジェクトを返すメソッド
  def current_user
    # @current_userに値があればそのまま使って、なければDBから探して代入
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # 現在ログインしているかを確認するメソッド（t/f）
  def logged_in?
    # current_userが存在したらtrue、しなかったらfalseを返す
    !!current_user
  end
end
