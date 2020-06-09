class Mypage::NotificationSettingsController < Mypage::BaseController

  # /mypage/notification_setting/edit
  def edit
    @user = User.find(current_user.id)
  end

  # 通知設定を更新する
  def update
    @user = User.find(current_user.id)
    # 設定を更新できた場合
    if @user.update(notification_settings_params)
      redirect_to edit_mypage_notification_setting_path, success: '設定を更新しました'
    # 更新出来なかった場合
    else
      flash.now[:danger] = '設定の更新に失敗しました'
      render :edit
    end
  end

  private

  # params[:user][:notification_on_comment],params[:user][:notification_on_like],params[:user][:notification_on_follow]を許可
  def notification_settings_params
    params.require(:user).permit(:notification_on_comment, :notification_on_like, :notification_on_follow)
  end
end
