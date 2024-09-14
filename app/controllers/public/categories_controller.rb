class Public::CategoriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = current_user
    @category = Category.new
    @categories = current_user.categories
    # ソート(モデルに記述あり)
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_categories = Category.sort_categories(@sort_order).where(user_id: current_user.id)
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to new_category_path, notice: "カテゴリを登録しました。"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @user = current_user
    @category = Category.find(params[:id])
    @title = Title.new
    @titles = @category.titles
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_titles = @category.titles.sort_titles(@sort_order)
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    redirect_to new_category_path, notice: "カテゴリを削除しました。"
  end

  private

  def category_params
    params.require(:category).permit(:category_name)
  end
end