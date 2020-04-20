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

  # userが削除されるとpostも削除される
  has_many :posts, dependent: :destroy
  # userが削除されるとcommentも削除される
  has_many :comments, dependent: :destroy
  # userが削除されるとlikeも削除される
  has_many :likes, dependent: :destroy
  # 中間テーブルlikesを経由してpostモデルを参照している（多対多）
  has_many :like_posts, through: :likes, source: :post

  # 【Relationshipモデルのfollower_idにuser_idを格納する】
  # Relationモデルからactive_relationshipモデルにモデル名を変更
  # foreign_keyで親モデルの外部キー指定する（親はFollewerモデル）
  # Followerモデルが削除されるとactive_relationshipモデルも削除される
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  # 【Relationshipモデルのfollowed_idにuser_idを格納する】
  # Relationモデルからpassive_relationshipモデルにモデル名を変更
  # foreign_keyで親モデルの外部キー指定する（親はFollewedモデル）
  # Followedモデルが削除されるとpassive_relationshipモデルも削除される
  has_many :passive_relationships, class_name: 'Relationship',
                                    foreign_key: 'followed_id',
                                    dependent: :destroy

  # 自分がフォローしているユーザーと自分をフォローしているユーザーの関連付け
  # 中間テーブルactive_relationshipsを経由してfollowedモデルを参照している（多対多）
  has_many :following, through: :active_relationships, source: :followed
  # 中間テーブルpassive_relationshipsを経由してfollowerモデルを参照している（多対多）
  has_many :followers, through: :passive_relationships, source: :follower

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

  def follow(other_user)
    following << other_user
  end
end
