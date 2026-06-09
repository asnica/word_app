class UserMailer < ApplicationMailer
  # 基本送信アドレスの設定
  default from: 'hyein.h@asnica.co.jp'

  # 新規登録の歓迎メールメソッドを定義
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'ご登録ありがとうございます')
  end
end
