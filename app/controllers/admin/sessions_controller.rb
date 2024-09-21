class Admin::SessionsController < Devise::SessionsController
  before_action :redirect_if_user_signed_in, only: [:new, :create]

  def create
    sign_out(current_user) if user_signed_in?
    super
  end

  def after_sign_in_path_for(resource)
    admin_users_path
  end

  def after_sign_out_path_for(resource_or_scope)
    admin_path
  end

  private

  def redirect_if_user_signed_in
    if user_signed_in?
      redirect_to mypage_users_path, alert: "ユーザーとしてログインしています。"
    end
  end
end
