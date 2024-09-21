class Admin::SessionsController < Devise::SessionsController
  def create
    if user_signed_in? && current_user.admin?
      sign_out(current_user) # 管理者がログイン中ならログアウト
    elsif admin_signed_in? && !current_user.admin?
      sign_out(current_admin) # 一般ユーザーがログイン中ならログアウト
    end
    super
  end
  
  def after_sign_in_path_for(resource)
    admin_users_path
  end

  def after_sign_out_path_for(resource_or_scope)
    admin_path
  end
end
