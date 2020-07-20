# 共通化して切り出したい処理を書く
module SystemHelper
  # アカウントを作ってログインする
  # アカウントを作成→ログインページに移動→メールアドレス・パスワード入力→ログインする
  def login
    user = create(:user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: '0123456789'
    click_button 'ログイン'
  end

  # ログインする
  # ログインページに移動→メールアドレス・パスワード入力→ログインする
  def login_as(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: '0123456789'
    click_button 'ログイン'
  end
end