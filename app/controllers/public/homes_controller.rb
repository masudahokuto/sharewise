class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :redirect_if_admin, only: [:top, :about]

  def top
  end

  def about
  end
  # 管理者ログイン中の処理
  def redirect_if_admin
    if admin_signed_in?
      redirect_to admin_path, alert: "管理者はこのページにアクセスできません。"
    end
  end
end
