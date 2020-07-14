require 'rails_helper'
RSpec.describe Comment, type: :model do

  # バリデーションについて
  describe "バリデーション" do
    # validates :content, presence: true
    it '本文は必須であること' do
      comment = build(:comment, content: nil)
      comment.valid?
      expect(comment.errors[:content]).to include('を入力してください')
    end
    # validates :content, length: { maximum: 300 }
    it '本文は最大300文字であること' do
      comment = build(:comment, content: 'a' * 301)
      comment.valid?
      expect(comment.errors[:content]).to include('は300文字以内で入力してください')
    end
  end
end