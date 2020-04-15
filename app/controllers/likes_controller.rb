class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # Postモデルのidを探し、ログインしているユーザーが投稿にいいねする（like_postsにpost_idを追加）
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
  end

  # Likeモデルのlike_postsに追加したpost_idを探し、ログインしているユーザーはいいねを削除する
  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
