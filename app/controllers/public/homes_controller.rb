class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :redirect_if_admin, only: [:top, :about]

  def top
  end

  def about
  end

  def redirect_if_admin
    if admin_signed_in?
      redirect_to admin_path, alert: "管理者はこのページにアクセスできません。"
    end
  end
end
