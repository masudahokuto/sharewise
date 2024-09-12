# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    admin_users_path
  end

  def after_sign_out_path_for(resource_or_scope)
    admin_path
  end
end
