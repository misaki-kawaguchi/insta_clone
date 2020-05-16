class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[read]

  # /activities/:id/read
  def read
    # ログインしているユーザーのactivityをとってくる
    activity = current_user.activities.find(params[:id])
    # 未読の場合は既読に更新する
    # activity.update(read: true) if activity.read == falseの略
    activity.read! if activity.unread?
    # フォローしたユーザー、コメント・いいねした投稿のページにリダイレクトする
    redirect_to activity.redirect_path
  end
end
