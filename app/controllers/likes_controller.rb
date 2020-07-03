class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # パラメータとして渡ってきたpost_idを元にPostテーブルから対象のレコードを取得し、ログインしているユーザーが投稿にいいねする（like_postsにpost_idを追加）
  def create
    @post = Post.find(params[:post_id])
    # いいねしている且つ通知設定をしている場合にメールを送る（like_post.html.slimの内容）
    # user_from（誰から）：ログインしているユーザー（いいねした人）、user_to（誰に）：投稿したユーザー（いいねされた人）
    UserMailer.with(user_from: current_user, user_to: @post.user, post: @post).like_post.deliver_later if current_user.like(@post) && @post.user.notification_on_like?
  end

  # Likeモデルのlike_postsに追加したpost_idを探し、ログインしているユーザーはいいねを削除する
  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
