class UserMailer < ApplicationMailer
  # どのメールアドレスから送られたか設定
  default from: 'instaclone@example.com'

  def like_post
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @post = params[:post]
    # メールのToとSubjectを設定。To→いいねされた人、Subject→メールのタイトル（誰がいいねしたか）
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたの投稿にいいねしました")
  end

  def comment_post
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @comment = params[:comment]
    # メールのToとSubjectを設定。To→コメントされた人、Subject→メールのタイトル（誰がコメントしたか）
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたの投稿にコメントしました")
  end

  def follow
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    # メールのToとSubjectを設定。To→フォローされた人、Subject→メールのタイトル（誰がフォローしたか）
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたをフォローしました")
  end
end
