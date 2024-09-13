class Public::ContentsController < ApplicationController

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
  end

  def edit
  end

  private

  def content_params
    params.require(:content).permit(:content_name, :body, images: [])
  end
end
