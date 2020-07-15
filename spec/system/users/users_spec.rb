# ユーザー登録・フォローについて
RSpec.describe 'ユーザー登録', type: :system do

  # ユーザー登録について
  describe 'ユーザー登録' do
    context '入力情報が正しい場合' do
      it 'ユーザー登録ができること' do
        # ユーザー登録ページにとぶ
        visit new_user_path
        # ユーザー名を入力
        fill_in 'ユーザー名', with: '山田太郎'
        # メールアドレスを入力
        fill_in 'メールアドレス', with: 'sample@example.com'
        # パスワードを入力
        fill_in 'パスワード', with: '0123456789'
        # 再度パスワードを入力
        fill_in 'パスワード確認', with: '0123456789'
        # 登録ボタンを押す
        click_button '登録'
        # 現在のページが特定のパス（ログインページ）であることを検証する
        expect(current_path).to eq login_path
        # ユーザー登録に成功したことを検証する（page内にユーザーを作成しましたというテキストが存在するかどうかを確認する）
        expect(page).to have_content 'ユーザーを作成しました'
      end
    end

    context '入力情報に間違いがある場合' do
      it 'ユーザー登録に失敗すること' do
        # ユーザー登録ページにとぶ
        visit new_user_path
        # ユーザー名を空のままにする
        fill_in 'ユーザー名', with: ''
        # メールアドレスを空のままにする
        fill_in 'メールアドレス', with: ''
        # パスワードを空のままにする
        fill_in 'パスワード', with: ''
        # パスワード確認を空のままにする
        fill_in 'パスワード確認', with: ''
        # 登録ボタンを押す
        click_button '登録'
        # ユーザー登録に失敗したことを検証する（page内に下記のテキストが存在するかどうかを確認する）
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_content 'パスワード確認を入力してください'
        expect(page).to have_content 'ユーザーの作成に失敗しました'
      end
    end
  end

  # フォローについて
  describe 'フォロー' do
  end
end