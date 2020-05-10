class Mypage::BaseController < ApplicationController
  before_action :require_login
  # layout/mypage.html.slim作成、layout/mypage.html.slimのレイアウトを適用する
  layout 'mypage'
end
