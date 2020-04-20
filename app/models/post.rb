# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  # PostモデルにCarrierwaveを関連付けている、複数画像の場合はmount_uploadersにする
  mount_uploaders :images, PostImageUploader
  # テキスト型のカラムに配列を格納する
  serialize :images, JSON

  validates :images, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  # postが削除されるとcommentも削除される
  has_many :comments, dependent: :destroy
  # postが削除されるとlikeも削除される
  has_many :likes, dependent: :destroy
  # 中間テーブルlikesを経由してuserモデルを参照している（多対多）
  has_many :like_users, through: :likes, source: :user
end
