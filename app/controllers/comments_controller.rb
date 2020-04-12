class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  # ログインしているユーザーのコメントを作成し、保存する
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  # ログインしているユーザーのコメントを探す
  def edit
    @comment = current_user.comments.find(params[:id])
  end

  # ログインしているユーザーのコメントを探しアップデートする
  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  # ログインしているユーザーのコメントを探し削除する
  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  # params[:comment][:content],params[:comment][post_id]を許可
  # 1つのpostに対して複数のコメントが紐づいていて、それはcomment.rbが持っているpost_idで繋がっている
  def comment_params
    params.require(:comment).permit(:content).merge(post_id: params[:post_id])
  end

  # params[:comment][:content]を許可
  def comment_update_params
    params.require(:comment).permit(:content)
  end
end
