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
    @category = Category.find(params[:id])
    @title = Title.new
    @titles = @category.titles
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    redirect_to new_category_path, notice: "カテゴリを削除しました。"
  end

  private

  def sort_categories(sort_order)
    if sort_order == 'alphabetical'
      Category.all.order(Arel.sql("CASE
        WHEN substr(category_name, 1, 1) GLOB '[0-9]*' THEN 1
        WHEN substr(category_name, 1, 1) GLOB '[a-zA-Z]*' THEN 2
        WHEN substr(category_name, 1, 1) GLOB '[ぁ-ん]*' THEN 3
        WHEN substr(category_name, 1, 1) GLOB '[一-龥]*' THEN 4
        ELSE 5
      END, category_name"))
    else
      Category.all.order(:created_at)
    end
  end

  def category_params
    params.require(:category).permit(:category_name)
  end
end