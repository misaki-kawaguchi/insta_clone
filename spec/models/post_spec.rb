require 'rails_helper'

RSpec.describe Post, type: :model do

  # バリデーションについて
  describe 'バリデーション' do
    # validates :images, presence: true
    it '画像は必須であること' do
      post = build(:post, images: nil)
      post.valid?
      expect(post.errors[:images]).to include('を入力してください')
    end

    # validates :body, presence: true, length: { maximum: 500 }
    it '本文は最大500文字であること' do
      post = build(:post, body: "a" * 1001)
      post.valid?
      expect(post.errors[:body]).to include('は500文字以内で入力してください')
    end
  end

  #スコープについて
  describe 'スコープ' do
    describe 'body_contain' do
      # example の実行前に let! が実行される
      let!(:post) { create(:post, body: 'hello world') }
      subject { Post.body_contain('hello') }
      it { is_expected.to include post }
    end
  end
end
