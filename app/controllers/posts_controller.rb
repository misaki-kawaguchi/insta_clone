class PostsController < ApplicationController

  # Sorceryが提供しているメソッド（認証済みか否かを判定する）
  before_login :require_login, only: %i[:new, :create, :edit, :update, :deatroy]

  #/posts
  def index
    # userとpostのテーブルからデータを取得（N+1問題）
    # 降順に並べる
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end

  def edit
  end

  def new
  end

  def show
  end
end
