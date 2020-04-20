class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # ログインしているユーザーが別のユーザーをフォローする（followingにfollowed_id（フォローされたユーザーのID）を追加する）
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
  end
end
