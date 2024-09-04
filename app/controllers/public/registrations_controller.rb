# frozen_string_literal: true

class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  # サインイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    mypage_users_path
  end

  # サインアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # 新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    mypage_users_path
  end

  # 更新後のリダイレクト先
  def after_update_path_for(resource)
    mypage_users_path
  end

  protected

  # サインアップ時に許可するパラメータの設定
def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [
    :last_name, 
    :first_name, 
    :nick_name, 
    :profile, 
    :gender, 
    :birthday, 
    :email, 
    :password, 
    :password_confirmation, 
    :profile_image
  ])
  devise_parameter_sanitizer.permit(:account_update, keys: [
    :last_name, 
    :first_name, 
    :nick_name, 
    :profile, 
    :gender, 
    :birthday, 
    :email, 
    :password, 
    :password_confirmation, 
    :current_password, 
    :profile_image
  ])
end
end
