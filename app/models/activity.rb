# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default(FALSE), not null
#  subject_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_activities_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_activities_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  # モデルで～_pathを使う場合に記述する
  include Rails.application.routes.url_helpers
  belongs_to :user
  # subjectを利用してポリモーフィックス関連付けを行う
  belongs_to :subject, polymorphic: true

  # 通知を新しい順に表示する、引数を渡すことにより表示件数を調整できる
  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  # アクション区分
  # enum：モデルの数値カラムに対して文字列による名前定義をマップすることができる
  enum action_type: {
    commented_to_own_post: 0, # コメント
    liked_to_own_post:     1, # いいね
    followed_me:           2  # フォロー
  }

  # 既読区分
  enum read: {
    unread: false, #未読
    read:   true   #既読
  }

  # リダイレクト先を設定
  def redirect_path
    # action_typeを比較対象とする（:commented_to_own_post、:liked_to_own_post、:followed_meに変換する）
    case action_type.to_sym
    # コメントの場合
    when :commented_to_own_post
      post_path(subject.post, anchor: "comment-#{subject.id}")
    # いいねの場合
    when :liked_to_own_post
      post_path(subject.post)
    # フォローの場合
    when :followed_me
      user_path(subject.follower)
    end
  end
end
