# 投稿について

require 'rails_helper'

RSpec.describe '投稿', type: :system do
  describe '投稿一覧' do
    # let!:事前に実行される
    # userはユーザー登録する
    let!(:user) { create(:user) }
    #投稿を作成
    let!(:post_1_by_others) { create(:post) }
    #投稿を作成
    let!(:post_2_by_others) { create(:post) }
    # ユーザー登録したユーザーが投稿を作成
    let!(:post_by_user) { create(:post, user: user) }

    context 'ログインしている場合' do
      # userがログインする、post_1_by_othersのuserをフォローする（テストの実行前に毎回実行される）
      before do
        login_as user
        user.follow(post_1_by_others.user)
      end
      it 'フォロワーと自分の投稿が表示されること' do
        # 投稿一覧にとぶ
        visit root_path
        # post_1_by_othersの投稿は表示される
        expect(page).to have_content post_1_by_others.body
        # post_1_by_userの投稿は表示される
        expect(page).to have_content post_by_user.body
        # post_1_by_othersの投稿は表示されない（フォローしていないため）
        expect(page).not_to have_content post_2_by_others.body
      end
    end

    context 'ログインしていない場合' do
      it '全ての投稿が表示されること' do
        # 投稿一覧にとぶ
        visit root_path
        # 投稿は全て表示される
        expect(page).to have_content post_1_by_others.body
        expect(page).to have_content post_2_by_others.body
        expect(page).to have_content post_by_user.body
      end
    end
  end

  describe '投稿' do
    it '画像を投稿できること' do
      # ログインする
      login
      # 新規投稿ページにとぶ
      visit new_post_path
      # 検索の影響範囲を制限する（投稿フォーム）
      within '#posts_form' do
        # ファイルセレクタにファイルを設定する
        attach_file '画像', Rails.root.join('spec', 'fixtures', 'profile-placeholder.png')
        # 本文入力
        fill_in '本文', with: 'This is an example post'
        # 登録ボタンを押す
        click_button '登録する'
      end
      # 投稿に成功しましたいうテキストが存在するかどうかを確認する
      expect(page).to have_content '投稿に成功しました'
    end
  end

  describe '投稿更新' do
    # let!:事前に実行される
    # userはユーザー登録する
    let!(:user) { create(:user) }
    #投稿を作成
    let!(:post_1_by_others) { create(:post) }
    #投稿を作成
    let!(:post_2_by_others) { create(:post) }
    # ユーザー登録したユーザーが投稿を作成
    let!(:post_by_user) { create(:post, user: user) }

    # userがログインする
    before do
      login_as user
    end
    it '自分の投稿に編集ボタンと削除ボタンが表示されること' do
      # 投稿一覧ページにとぶ
      visit root_path
      # 検索の影響範囲を制限する（投稿）
      within "#post-#{post_by_user.id}" do
        # .delete-buttonと.edit-buttonが存在するかどうかを確認する
        expect(page).to have_css '.delete-button'
        expect(page).to have_css '.edit-button'
      end
    end

    it '他人の投稿には削除ボタンが表示されないこと' do
      # userはpost_1_by_othersのuserをフォローする
      user.follow(post_1_by_others.user)
      # 投稿一覧ページにとぶ
      visit root_path
      # 検索の影響範囲を制限する（投稿）
      within "#post-#{post_1_by_others.id}" do
        # .delete-buttonと.edit-buttonが存在しないかどうかを確認する
        expect(page).not_to have_css '.delete-button'
        expect(page).not_to have_css '.edit-button'
      end
    end

    it '投稿が更新できること' do
      # userの投稿編集ページにとぶ
      visit edit_post_path(post_by_user)
      # 検索の影響範囲を制限する（投稿編集フォーム）
      within '#posts_form' do
        attach_file '画像', Rails.root.join('spec', 'fixtures', 'profile-placeholder.png')
        fill_in '本文', with: 'This is an example updated post'
        # 更新する
        click_button '更新する'
      end
      # 投稿を更新しましたというテキストが存在するかどうかを確認する
      expect(page).to have_content '投稿を更新しました'
    end
  end

  describe '投稿削除' do
    # let!:事前に実行される
    # userはユーザー登録する
    let!(:user) { create(:user) }
    #投稿を作成
    let!(:post_1_by_others) { create(:post) }
    # ユーザー登録したユーザーが投稿を作成
    let!(:post_by_user) { create(:post, user: user) }

    # userがログインする
    before do
      login_as user
    end

    it '自分の投稿に削除ボタンが表示されること' do
      # 投稿一覧ページにとぶ
      visit root_path
      # 検索の影響範囲を制限する（投稿）
      within "#post-#{post_by_user.id}" do
        # .delete-buttonが存在するかどうかを確認する
        expect(page).to have_css '.delete-button'
      end
    end

    it '他人の投稿には削除ボタンが表示されないこと' do
      # userはpost_1_by_othersのuserをフォローする
      user.follow(post_1_by_others.user)
      # 投稿一覧ページにとぶ
      visit root_path
      # 検索の影響範囲を制限する（投稿）
      within "#post-#{post_1_by_others.id}" do
        # .delete-buttonが存在しないどうかを確認する
        expect(page).not_to have_css '.delete-button'
      end
    end

    it '投稿が削除できること' do
      # 投稿一覧ページにとぶ
      visit root_path
      within "#post-#{post_by_user.id}" do
      # OKボタンを押す
        page.accept_confirm { find('.delete-button').click }
      end
      # 投稿を削除しましたというテキストが存在するかどうかを確認する
      expect(page).to have_content '投稿を削除しました'
      # 投稿が削除されたかどうか検証する
      expect(page).not_to have_content post_by_user.body
    end
  end

  describe '投稿詳細' do
    # userがユーザー登録する
    let(:user) { create(:user) }
    # userが投稿する
    let(:post_by_user) { create(:post, user: user) }

    # userがログインする
    before do
      login_as user
    end

    it '投稿の詳細画面が閲覧できること' do
      # 投稿詳細ページにとぶ
      visit post_path(post_by_user)
      # 現在のページが特定のパス（投稿詳細ページ）であることを検証する
      expect(current_path).to eq post_path(post_by_user)
    end
  end

  describe 'いいね' do
    # userがユーザー登録、投稿する
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }

    # ログインして投稿したユーザーをフォローする
    before do
      login_as user
      user.follow(post.user)
    end

    it 'いいねをできること' do
      # 投稿詳細ページにとぶ
      visit post_path(post)
      expect {
        # 検索の影響範囲を制限する（いいねボタン）
        within "#like_area-#{post.id}" do
          # .like-buttonをクリック
          find('.like-button').click
          # cssが.unlike-buttonになることを検証する
          expect(page).to have_css '.unlike-button'
        end
      # いいねした投稿の数が1になる
      }.to change(user.like_posts, :count).by(1)
    end

    it 'いいねを取り消せること' do
      # userが投稿をいいねする
      user.like(post)
      # 投稿詳細ページにとぶ
      visit post_path(post)
      expect {
        # 検索の影響範囲を制限する（いいねボタン）
        within "#like_area-#{post.id}" do
          # .unlike-buttonをクリック
          find('.unlike-button').click
          # cssが.like-buttonになることを検証する
          expect(page).to have_css '.like-button'
        end
      # いいねした投稿の数が-1になる
      }.to change(user.like_posts, :count).by(-1)
    end
  end
end