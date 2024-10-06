class Public::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :destroy, :update]
  before_action :authorize_user!, only: [:show, :destroy, :update]

  def new
    @category = Category.new
    @categories = current_user.categories
    # ソート(モデルに記述あり)
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_categories = Category.sort_categories(@sort_order).where(user_id: current_user.id)
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
       flash[:success] = "もくじを作成しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "エラーが発生しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    # set_categoryとauthorize_user!で、他ユーザーのアクセスを防止済み
    @title = Title.new
    @titles = @category.titles
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_titles = @category.titles.sort_titles(@sort_order)
  end

  def update
    if @category.update(category_params)
      respond_to do |format|
        format.html { redirect_to new_category_path, notice: 'もくじが更新されました。' }
      end
    else
      flash[:alert] = "エラーが発生しました"
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def destroy
    @category.destroy
    redirect_back(fallback_location: root_path, alert: 'もくじが削除されました。')
  end

  private

  def set_category
    # パラメータで渡されたカテゴリを取得
    @category = Category.find(params[:id])
  end

  def authorize_user!
    # current_userがそのカテゴリの所有者であるか確認
    redirect_to root_path, alert: 'アクセス権がありません' unless @category.user == current_user
  end

  def category_params
    params.require(:category).permit(:category_name)
  end
end
