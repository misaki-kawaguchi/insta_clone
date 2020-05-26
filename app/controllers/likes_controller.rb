class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # パラメータとして渡ってきたpost_idを元にPostテーブルから対象のレコードを取得し、ログインしているユーザーが投稿にいいねする（like_postsにpost_idを追加）
  def create
    @post = Post.find(params[:post_id])
    if current_user.like(@post)
      # いいねした後にメールを送る（like_post.html.slimの内容）
      UserMailer.with(
        # 誰から（いいねした人）：ログインしているユーザー
        user_from: current_user,
        # 誰に（いいねされた人）：投稿したユーザー
        user_to: @post.user,
        # 投稿（Post.find(params[:post_id])）
        post: @post
      ).like_post.deliver_later
    end
  end

  # Likeモデルのlike_postsに追加したpost_idを探し、ログインしているユーザーはいいねを削除する
  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
