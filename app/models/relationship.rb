# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
class Relationship < ApplicationRecord
  # FollowerモデルとFollowedモデルを作成（Userモデルからモデル名を変更）
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  # as: :subjectにより、ポリモーフィック関連付けする。relationshipが削除されるとactivityもで削除される
  has_one :activity, as: :subject, dependent: :destroy
  # 空欄だとエラーになる
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # follower_idとfollowed_idは重複しない
  validates :follower_id, uniqueness: { scope: :followed_id }
  
  # 誰かをフォローした時にcreate_activitiesを行う
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(
      subject: self, # 自分自身と紐付ける
      user: followed, # 誰をフォローしたか
      action_type: :followed_me # アクションタイプを作成
    )
  end
end
