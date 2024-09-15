class Public::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :destroy]
  before_action :authorize_user!, only: [:show, :destroy]

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
      redirect_to new_category_path, notice: "カテゴリを登録しました。"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    # set_category と authorize_user! により、他ユーザーのアクセスを防止済み
    @title = Title.new
    @titles = @category.titles
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_titles = @category.titles.sort_titles(@sort_order)
  end

  def destroy
    # set_category と authorize_user! により、他ユーザーの削除を防止済み
    @category.destroy
    redirect_to new_category_path, notice: "カテゴリを削除しました。"
  end

  private

  def set_category
    # パラメータで渡されたカテゴリを取得
    @category = Category.find(params[:id])
  end

  def authorize_user!
    # current_user がそのカテゴリの所有者であるか確認
    redirect_to root_path, alert: 'アクセス権がありません' unless @category.user == current_user
  end

  def category_params
    params.require(:category).permit(:category_name)
  end
end
