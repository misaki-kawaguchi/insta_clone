require 'rails_helper'

RSpec.describe User, type: :model do

  # バリデーションについて
  describe 'バリデーション' do
    # validates :username, presence: true
    it 'ユーザー名は必須であること' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    # validates :username, uniqueness: true
    it 'ユーザー名は一意であること' do
      user = create(:user)
      same_name_user = build(:user, username: user.username)
      same_name_user.valid?
      expect(same_name_user.errors[:username]).to include('はすでに存在します')
    end

    # validates :email, presence: true
    it 'メールアドレスは必須であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    # validates :email, uniqueness
    it 'メールアドレスは一意であること' do
      user = create(:user)
      same_email_user = build(:user, email: user.email)
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end
  end

  #インスタンスメソッドについて
  describe 'インスタンスメソッド' do
    # let:呼ばれたときに 初めてデータを読み込む、遅延読み込み を実現するメソッド
    # user_a,user_b,user_cがアカウント作成
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:user_c) { create(:user) }
    # user_a,user_b,user_cが投稿する
    let(:post_by_user_a) { create(:post, user: user_a) }
    let(:post_by_user_b) { create(:post, user: user_b) }
    let(:post_by_user_c) { create(:post, user: user_c) }

    # 自分のオブジェクトかどうか
    describe 'own?' do
      context '自分のオブジェクトの場合' do
        it 'trueを返す' do
          expect(user_a.own?(post_by_user_a)).to be true
        end
      end

      context '自分以外のオブジェクトの場合' do
        it 'falseを返す' do
          expect(user_a.own?(post_by_user_b)).to be false
        end
      end
    end

    
  end
end
