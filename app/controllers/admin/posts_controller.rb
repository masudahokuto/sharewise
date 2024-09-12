class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
    @admin_users = User.page(params[:page]).per(50)
      @gender_counts = {
      male: User.where(gender: :male).count,
      female: User.where(gender: :female).count,
      other: User.where(gender: :other).count
    }

    @total_users = @admin_users.count
    @total_users = User.count
    @inactive_users = User.where(is_active: false).count
    @active_users = @total_users - @inactive_users
    @age_distribution = age_distribution
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @post_comment = @post.post_comments.build
    @post_comments = @post.post_comments.page(params[:page]).per(10)
  end

  def destroy
    @post = Post.find(params[:id])
  end

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

  private

  def post_params
    params.require(:post).permit(:body, :user_id, images: [])
  end
end
