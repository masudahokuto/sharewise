class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    # 検索クエリがある場合、本文を検索
    @posts = params[:query].present? ? Post.search_by_body(params[:query]) : Post.all

    # ソート条件の分岐
    case params[:sort]
    when 'favorites_count' # 通算いいね多い順
      @posts = @posts.order_by_favorites_count
    when 'daily_favorites' # 日間いいね多い順
      @posts = @posts.order_by_daily_favorites_count
    when 'weekly_favorites' # 週間いいね多い順
      @posts = @posts.order_by_weekly_favorites_count
    when 'monthly_favorites' # 月間いいね多い順
      @posts = @posts.order_by_monthly_favorites_count
    else
      @posts = @posts.order(created_at: :desc) # デフォルトは作成日順
    end

    @posts = @posts.page(params[:page]).per(10)

    # その他のデータ
    @admin_users = User.page(params[:admin_user_page]).per(50)

    # 性別のカウント
    @gender_counts = {
      male: User.where(gender: :male).count,
      female: User.where(gender: :female).count,
      other: User.where(gender: :other).count
    }

    # ユーザー全体数
    @total_users = User.count
    @inactive_users = User.where(is_active: false).count
    @active_users = @total_users - @inactive_users

    # 年齢分布データの取得
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
    @post.destroy
    redirect_to admin_posts_path
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
