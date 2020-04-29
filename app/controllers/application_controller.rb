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

  # 指定したキーがないときにエラーを出さないようにする、パラメーターがなかったときは{}がデフォルト値として評価される
  def search_post_params
    params.fetch(:q, {}).permit(:body)
  end
end
