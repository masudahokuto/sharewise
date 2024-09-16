class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @current_user = current_user
    @users = User.where('nick_name LIKE ? AND is_active = ?', "%#{params[:query]}%", true).page(params[:page]).per(10)
  end
end