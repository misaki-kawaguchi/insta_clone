class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # ログインしているユーザーが別のユーザーをフォローする（followingにfollowed_id（フォローされたユーザーのID）を追加する）
  def create
    @user = User.find(params[:followed_id])
    if current_user.follow(@user)
      UserMailer.with(
        # 誰から（フォローした人）：ログインしているユーザー
        user_from: current_user,
        # 誰に（フォローされた人）：ユーザー
        user_to: @user,
      ).follow_user.deliver_later
    end
  end

  # relationshipモデルからフォローしているユーザーを探し（followed_id）、ログインしているユーザーはフォローを解除する
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
