class Public::ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  def new
    @category = Category.find(params[:category_id])
    @title = @category.titles.find(params[:title_id])
    @genre = @title.genres.find(params[:genre_id])
    @content = @genre.contents.new
    @user = current_user
  end

  def create
    @category = Category.find(params[:category_id])
    @title = @category.titles.find(params[:title_id])
    @genre = @title.genres.find(params[:genre_id])
    @content = @genre.contents.new(content_params)
    if @content.save
      redirect_to category_title_genre_content_path(@category, @title, @genre, @content), notice: 'コンテンツが登録されました。'
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @content = @genre.contents.find(params[:id])
    @genre = @content.genre
    @title = @genre.title
    @category = @title.category
    @user = @content.genre.title.category.user
  end

  def edit
    @category = Category.find(params[:category_id])
    @title = @category.titles.find(params[:title_id])
    @genre = @title.genres.find(params[:genre_id])
    @content = @genre.contents.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])
    @title = @category.titles.find(params[:title_id])
    @genre = @title.genres.find(params[:genre_id])
    @content = @genre.contents.find(params[:id])

    if @content.update(content_params)
      redirect_to category_title_genre_path(@category, @title, @genre), notice: 'コンテンツが更新されました。'
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if current_user == @content.genre.title.category.user
      @content.destroy
      flash[:notice] = "コンテンツが削除されました。"
      redirect_to category_title_genre_path(@category, @title, @genre), notice: 'コンテンツが削除されました。'
    else
      redirect_to mypage_path
    end
  end

  def set_content
    @category = Category.find_by(id: params[:category_id])
    @title = @category.titles.find_by(id: params[:title_id]) if @category
    @genre = @title.genres.find_by(id: params[:genre_id]) if @title
    @content = @genre.contents.find_by(id: params[:id]) if @genre
  end

  private

  def content_params
    params.require(:content).permit(:content_name, :body, images: [])
  end
end
