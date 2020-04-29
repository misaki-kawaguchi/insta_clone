class PostsController < ApplicationController
  # Sorceryが提供しているメソッド（認証済みか否かを判定する）
  before_action :require_login, only: %i[new create edit update destroy]

  # /posts
  # userとpostのテーブルからデータを取得（N+1問題）
  # 降順に並べる
  def index
    # ログインしている場合は自分とフォローしているユーザーの投稿を、ログインしていない場合は全ての投稿を表示する
    @posts = if current_user
               current_user.feed.includes(:user).page(params[:page]).order(created_at: :desc)
             else
               Post.all.includes(:user).page(params[:page]).order(created_at: :desc)
             end
    # 登録日が新しい順に5件分表示する
    @users = User.recent(5)
  end

  # /posts/new
  def new
    @post = Post.new
  end

  # ログインしているユーザーが投稿できる
  # 保存できたらトップページに戻る。保存できない場合は新規投稿ページに戻る
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿に成功しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  # /post/:id/edit
  # ログインしているユーザーのみ編集できる
  def edit
    @post = current_user.posts.find(params[:id])
  end

  # ログインしているユーザーの投稿を探す
  # 更新できたらトップページに戻る。更新できない場合が編集ページに戻る。
  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, success: '投稿を更新しました'
    else
      flash.now[:danger] = '投稿の保存に失敗しました'
      render :edit
    end
  end

  # /post/:id
  def show
    @post = Post.find(params[:id])
    # commentsを降順に並べる
    @comments = @post.comments.order(created_at: :desc)
    # commentの新規作成
    @comment = Comment.new
  end

  # ログインしているユーザーのみ削除できる
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:body, images: [])
  end
end
