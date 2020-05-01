class ApplicationController < ActionController::Base
  before_action :set_search_posts_form
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  # ヘッダー部分（共通部分に）検索フォームを設置するのでApplicationControllerに実装する
  # SearchPostsForm（通常のモデルと同じように扱う）を新規作成（bodyを渡す）し、@search_formに代入
  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
  end

  # params.fetch(:q, {})はparams[:q]が空の場合{}を、params[:q]が空でない場合はparams[:q]を返してくれる
  # params[:q][:body]で値を取り出す
  def search_post_params
    params.fetch(:q, {}).permit(:body)
  end
end
