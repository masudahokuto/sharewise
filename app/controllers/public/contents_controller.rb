class Public::ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  def new
    @category = Category.find(params[:category_id])
    @title = @category.titles.find(params[:title_id])
    @genre = @title.genres.find(params[:genre_id])
    @content = @genre.contents.new
    @user = current_user
    @include_clock_js = true
    @links = Link.all
  end

  def create
    @category = Category.find(params[:category_id])
    @title = @category.titles.find(params[:title_id])
    @genre = @title.genres.find(params[:genre_id])
    @content = @genre.contents.new(content_params)
    if @content.save
      if params[:save_and_show]
        flash[:success] = "ページを作成しました"
        redirect_to category_title_genre_content_path(@category, @title, @genre, @content)
      elsif params[:save_and_new]
        flash[:success] = "ページを作成しました"
        redirect_to new_category_title_genre_content_path(@category, @title, @genre)
      else
        redirect_to new_category_title_genre_content_path(@category, @title, @genre)
      end
    else
      flash[:alert] = "エラーが発生しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @genre = @content.genre
    @title = @genre.title
    @category = @title.category
    @user = current_user
  end

  def edit
    # @content は set_content コールバックで設定されている
    @user = current_user
  end

  def update
    # @content は set_content コールバックで設定されている
    if @content.update(content_params)
      redirect_to category_title_genre_path(@category, @title, @genre), notice: 'コンテンツが更新されました。'
    else
      flash[:alert] = "エラーが発生しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @content.destroy
    flash[:notice] = "コンテンツが削除されました。"
    redirect_to category_title_genre_path(@category, @title, @genre)
  end

  private

  def set_content
    @category = Category.find_by(id: params[:category_id])
    @title = @category.titles.find_by(id: params[:title_id]) if @category
    @genre = @title.genres.find_by(id: params[:genre_id]) if @title
    @content = @genre.contents.find_by(id: params[:id]) if @genre
  end

  def authorize_user!
    # @content から関連するカテゴリを取得
    @category = @content.genre.title.category
    # current_user がカテゴリの所有者であることを確認
    redirect_to mypage_path, alert: 'アクセス権がありません' unless @category.user == current_user
  end

  def content_params
    params.require(:content).permit(:content_name, :body, images: [])
  end
end
