class Public::CategoriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @categories = current_user.categories
    @category = Category.new
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

  def category_params
    params.require(:category).permit(:category_name)
  end
end