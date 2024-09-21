class Public::TitlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title, only: [:show, :destroy, :update]
  before_action :authorize_user!, only: [:show, :destroy]

  def show
    @category = Category.find(params[:category_id])
    @genres = @title.genres
    @genre = Genre.new
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_genres = @title.genres.sort_genres(@sort_order)
  end

  def create
    @category = Category.find(params[:category_id])
    @title = @category.titles.new(title_params)
    if @title.save
       flash[:success] = "もくじを作成しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "エラーが発生しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @category = Category.find(params[:category_id])
    if @title.update(title_params)
      respond_to do |format|
        format.js # JavaScriptでレスポンスを返す
        format.html { redirect_to category_path(@category), notice: 'もくじが更新されました。' }
      end
    else
      flash[:alert] = "エラーが発生しました"
      respond_to do |format|
        format.js
        format.html { render :show }
      end
    end
  end

  def destroy
    @title.destroy
    redirect_back(fallback_location: root_path, notice: 'もくじが削除されました。')
  end

  private

  def set_title
    @title = Title.find(params[:id])
  end

  def authorize_user!
    @category = Category.find(params[:category_id])
    # current_user がカテゴリの所有者であることを確認
    redirect_to root_path, alert: 'アクセス権がありません' unless @category.user == current_user
  end

  def title_params
    params.require(:title).permit(:title_name)
  end
end
