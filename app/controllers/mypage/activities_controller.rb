class Mypage::ActivitiesController < Mypage::BaseController
  before_action :require_login, only: %i[index]

  # mypage/activities
  # 通知リストに最新の10件を表示させる
  def index
    @activities = current_user.activities.order(created_at: :desc).page(params[:page]).per(10)
  end
end
