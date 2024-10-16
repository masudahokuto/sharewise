class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @current_user = current_user
    @posts = Post.active_user_posts
    @links = @current_user.present? ? @current_user.links : []

    # フォームが空の状態で検索ボタンが押された場合の処理
    if params[:query].blank?
      flash[:alert] = "検索内容を入力してください。"
      redirect_to users_path and return
    end

    @users = User.where('nick_name LIKE ? AND is_active = ?', "%#{params[:query]}%", true)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(10)

    if @users.empty?
      flash[:alert] = "ユーザーが見つかりませんでした。"
      redirect_to users_path and return
    end
  end

end