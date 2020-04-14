class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
  end

  def destroy
  end
end
