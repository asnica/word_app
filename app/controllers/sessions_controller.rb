class SessionsController < ApplicationController
  def new
    # ログイン画面を見せる
  end

  def create
    # 提出されたeメールアドレスでユーザーをDBから探す
    user =  User.find_by(email: params[:session][:email])

    # ユーザーが存在するか、パスワードが正しいか確認（authenticateメソッドを使う）
    if user && user.authenticate(params[:session][:password])
      # 成功したらsessionにIDをセーブ（ログイン状態になる）
      session[:user.id] = user.id
      redirect_to root_path, notice: "ログインしました。"
    else
      # 失敗したらエラーメッセージと一緒に改めてログイン画面を表示
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # sessionからユーザーIDを消す（ログアウト）
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
