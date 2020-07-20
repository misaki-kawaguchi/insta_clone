# ログイン・ログアウトについて
# spec/support配下のファイルを読み込む
require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  # 遅延読み込み（呼ばれたときに 初めてデータを読み込む）
  let(:user) { create(:user) }

  # ログインについて
  describe 'ログイン' do
    context '認証情報が正しい場合' do
      it 'ログインできること' do
        # ログインページにとぶ
        visit login_path
        # メールアドレスを入力
        fill_in 'メールアドレス', with: user.email
        # パスワードを入力
        fill_in 'パスワード', with: '0123456789'
        # ログインボタンを押す（submitボタンやbuttonタグの場合）
        click_button 'ログイン'
        # 現在のページが特定のパス（投稿一覧ページ）であることを検証する
        expect(current_path).to eq root_path
        # ログインに成功したことを検証する（page内にログインしましたというテキストが存在するかどうかを確認する）
        expect(page).to have_content 'ログインしました'
      end
    end

    context '認証情報に誤りがある場合' do
      it 'ログインできないこと' do
        # ログインページにとぶ
        visit login_path
        # メールアドレスを入力
        fill_in 'メールアドレス', with: user.email
        # パスワードを入力
        fill_in 'パスワード', with: '01234'
        # ログインボタンを押す（submitボタンやbuttonタグの場合）
        click_button 'ログイン'
        # 現在のページが特定のパス（ログインページ）であることを検証する
        expect(current_path).to eq login_path
        # ログインに失敗したことを検証する（page内にログインに失敗しましたというテキストが存在するかどうかを確認する）
        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end
  # ログアウトについて
  describe 'ログアウト' do
    # ログインする（テストの実行前に毎回実行される）
    before do
      login
    end
    it 'ログアウトできること' do
      # ログアウトボタンを押す
      click_on('ログアウト')
      # 現在のページが特定のパス（投稿一覧ページ）であることを検証する
      expect(current_path).to eq root_path
      # ログアウトに成功したことを検証する（page内にログアウトしましたというテキストが存在するかどうかを確認する）
      expect(page).to have_content 'ログアウトしました'
    end
  end
end