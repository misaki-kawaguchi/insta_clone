# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # as: :subjectにより、ポリモーフィック関連付けする。relationshipが削除されるとactivityもで削除される
  has_one :activity, as: :subject, dependent: :destroy
  validates :content, presence: true, length: { maximum: 300 }

  # 誰かの投稿にコメントした時にcreate_activitiesを行う
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(
      subject: self, # 自分自身と紐付ける
      user: post.user, # 誰の投稿にコメントしたか
      action_type: :commented_to_own_post # アクションタイプを作成する
    )
  end
end
