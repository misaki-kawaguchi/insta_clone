# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # postが削除されるとuserも削除される
  has_many :posts, dependent: :destroy
  # commentが削除されるとuserも削除される
  has_many :comments, dependent: :destroy
  # likeが削除されるとuserも削除される
  has_many :likes, dependent: :destroy
  # 中間テーブルlikesを経由してpostモデルを参照している（多対多）
  has_many :like_posts, through: :likes, source: :post

  # ユーザーと投稿したユーザーが一致するかどうか
  def own?(object)
    id == object.user_id
  end

  # like_postsにpost_idを追加する
  def like(post)
    like_posts << post
  end

  # like_postsに追加したpost_idを削除する
  def unlike(post)
    like_posts.destroy(post)
  end

  # like_postsにpost_idが含まれている場合はtrueを返す
  def like?(post)
    like_posts.include?(post)
  end
end
