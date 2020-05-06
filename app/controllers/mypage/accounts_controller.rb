class Mypage::AccountsController < Mypage::BaseController
  # /mypage/account/edit
  # 現在ログインしているユーザーのidを探す
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(account_params)
      redirect_to edit_mypage_account_path, success: 'プロフィールを更新しました'
    else
      flash.now['danger'] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private

  # :avatar_cache：画像を変更していない場合は、前回アップロードした画像は消えない
  def account_params
    params.require(:user).permit(:email, :username, :avatar, :avatar_cache)
  end
end
