class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!  # 管理者がログインしていることを確認
  before_action :set_user, only: %i[show update destroy]
  before_action :set_gender_counts, only: :index
  before_action :set_age_distribution, only: :index

  def index
    @admin_users = load_users.page(params[:page]).per(10)
    @total_users = User.count
    @inactive_users = User.where(is_active: false).count
    @active_users = @total_users - @inactive_users
  end

  def inactive
    @inactive_users = User.where(is_active: false).page(params[:page]).per(50)

    respond_to do |format|
      format.js # 非同期でJSのレスポンスを返す
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def update
    if @user.update(user_params)
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

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーが削除されました。'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def load_users
    if params[:query].present? && params[:search_field].present?
      User.search_by(params[:search_field], params[:query])
    else
      User
    end
  end

  def set_gender_counts
    @gender_counts = {
      male: User.where(gender: :male).count,
      female: User.where(gender: :female).count,
      other: User.where(gender: :other).count
    }
  end

  def set_age_distribution
    age_groups = {
      '19歳以下' => User.where('birthday > ?', 19.years.ago).count,
      '20歳〜29歳' => User.where('birthday <= ? AND birthday > ?', 19.years.ago, 29.years.ago).count,
      '30歳〜39歳' => User.where('birthday <= ? AND birthday > ?', 29.years.ago, 39.years.ago).count,
      '40歳〜49歳' => User.where('birthday <= ? AND birthday > ?', 39.years.ago, 49.years.ago).count,
      '50歳〜59歳' => User.where('birthday <= ? AND birthday > ?', 49.years.ago, 59.years.ago).count,
      '60歳以上' => User.where('birthday <= ?', 59.years.ago).count
    }

    total_users = User.count
    @age_distribution = age_groups.transform_values { |count| (count.to_f / total_users * 100).round(2) }
  end

  def user_params
    params.require(:user).permit(:is_active)
  end
end
