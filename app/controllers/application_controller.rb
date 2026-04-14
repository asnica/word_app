class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  # ログイン状態を確認し、ログインしていない場合ログインページへ移動
  def logged_in_user
    # logged_in?がfalseの場合
    unless logged_in?
      # エラーメッセージを含み、ログインページへ強制移動
      flash[:alert] = "ログインが必要です。"
      redirect_to login_url, status: :see_other
    end
  end

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
