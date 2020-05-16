# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # as: :subjectにより、ポリモーフィック関連付けする。relationshipが削除されるとactivityもで削除される
  has_one :activity, as: :subject, dependent: :destroy
  # 1つの投稿に対しては1ユーザー当たり1回しかいいねできない
  validates :user_id, uniqueness: { scope: :post_id }

  # 誰かの投稿にいいねした時にcreate_activitiesを行う
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(
      subject: self, # 自分自身と紐付ける
      user: post.user, # 誰の投稿にいいねしたか
      action_type: :liked_to_own_post # アクションタイプを作成
    )
  end
end
