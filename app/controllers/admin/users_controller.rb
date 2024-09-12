class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!  # 管理者がログインしていることを確認

  def index
    @admin_users = User.page(params[:page]).per(50)

    @gender_counts = {
      male: User.where(gender: :male).count,
      female: User.where(gender: :female).count,
      other: User.where(gender: :other).count
    }

    @total_users = @admin_users.count
    # 年齢分布のデータを取得
    @age_distribution = age_distribution
    @total_users = User.count
    @inactive_users = User.where(is_active: false).count
    @active_users = @total_users - @inactive_users
  end

  # 退会中のuserを取得
  def inactive
    @inactive_users = User.where(is_active: false).page(params[:page]).per(50) # is_activeがfalseのユーザーのみ取得

    respond_to do |format|
      format.js # 非同期でJSのレスポンスを返す
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      if @user.is_active?
        flash.now[:notice] = "顧客が再開されました"
      else
        flash.now[:alert] = "顧客が退会されました"
      end
      respond_to do |format|
        format.html { redirect_to admin_user_path(@user) }
        format.js   # update.js.erb を呼び出す
      end
    else
      flash.now[:alert] = "顧客情報の更新に失敗しました"
      respond_to do |format|
        format.html { render :edit }
        format.js   # エラーメッセージを表示するためのJS
      end
    end
  end

  private

  def age_distribution
    # 各年齢層ごとのユーザー数を集計
    age_groups = {
      '19歳以下' => User.where('birthday > ?', 19.years.ago).count,
      '20歳〜29歳' => User.where('birthday <= ? AND birthday > ?', 19.years.ago, 29.years.ago).count,
      '30歳〜39歳' => User.where('birthday <= ? AND birthday > ?', 29.years.ago, 39.years.ago).count,
      '40歳〜49歳' => User.where('birthday <= ? AND birthday > ?', 39.years.ago, 49.years.ago).count,
      '50歳〜59歳' => User.where('birthday <= ? AND birthday > ?', 49.years.ago, 59.years.ago).count,
      '60歳以上' => User.where('birthday <= ?', 59.years.ago).count
    }

    total_users = User.count

    # 割合を計算
    @age_distribution = age_groups.transform_values { |count| (count.to_f / total_users * 100).round(2) }
  end

  def user_params
    params.require(:user).permit(:is_active)
  end
end
# :last_name, :first_name, :nick_name, :profile, :gender, :birthday, :email, :profile_image,