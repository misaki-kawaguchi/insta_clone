class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # ログインしているユーザーが別のユーザーをフォローする（followingにfollowed_id（フォローされたユーザーのID）を追加する）
  def create
    @user = User.find(params[:followed_id])
    # フォロー後にメールを送る（follow_user.html.slimの内容）
    # user_from（誰から）：ログインしているユーザー（いいねした人）、user_to（誰に）：ユーザー（フォローされた人）
    UserMailer.with(user_from: current_user, user_to: @user).follow_user.deliver_later if current_user.follow(@user)
  end

  # relationshipモデルからフォローしているユーザーを探し（followed_id）、ログインしているユーザーはフォローを解除する
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
