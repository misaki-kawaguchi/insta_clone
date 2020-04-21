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

  # 【能動的関係（〇〇をフォローする）に対して1対多 (has_many) の関連付けを実装する（active_relationship）】
  # follower_idという外部キーを使い、active_relationshipsモデルを通してフォローしているユーザーを特定する
  # userモデルが削除されるとactive_relationshipモデルも削除される
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  # relationshipsテーブル（active_relationships）のfollowed_idを使ってフォローしたユーザーを探す
  # user.followedsは英語として不適切なため、user.followingという名前を使う
  # :sourceパラメーターを使いfollowing配列の元はfollowed idの集合であることを明示的に伝える
  has_many :following, through: :active_relationships, source: :followed

  # 【受動的関係（〇〇にフォローされている）に対して1対多 (has_many) の関連付けを実装する（passive_relationship）】
  # followed_idという外部キーを使い、passive_relationshipsモデルを通してフォロワーを特定する
  # userモデルが削除されるとpassive_relationshipモデルも削除される
  has_many :passive_relationships, class_name: 'Relationship',
                                    foreign_key: 'followed_id',
                                    dependent: :destroy

  # relationshipsテーブル（passive_relationships）のfollower_idを使ってフォロワーを探す
  # followers配列の元はfollower idの集合である
  # :sourceパラメーターを使いfollowers配列の元はfollower idの集合であることを明示的に伝える
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

  # followingにfollowed_idを追加する
  def follow(other_user)
    following << other_user
  end

  # followingに追加したfollower_idを削除する
  def unfollow(other_user)
    following.destroy(other_user)
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
end
