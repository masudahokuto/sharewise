class Public::TitlesController < ApplicationController
  def show
    @title = Title.find(params[:id])
    @category = Category.find(params[:category_id])
    @genres = @title.genres
    @genre = Genre.new
  end

  def create
    @category = Category.find(params[:category_id])
    @title = @category.titles.new(title_params)
    if @title.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @title = Title.find(params[:id])
    @title.destroy
   redirect_back(fallback_location: root_path)
  end

  private

  def title_params
    params.require(:title).permit(:title_name)
  end
end