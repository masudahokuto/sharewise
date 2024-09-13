class Public::GenresController < ApplicationController
  def show
    @genre = Genre.find(params[:id])
    @title = @genre.title
    @category = @title.category
    @contents = @genre.contents
    @content = Content.new
  end

  def create
    @title = Title.find(params[:title_id])
    @genre = @title.genres.new(genre_params)
    if @genre.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy
    redirect_back(fallback_location: root_path, notice: 'ジャンルが削除されました。')
  end

  private

  def genre_params
    params.require(:genre).permit(:genre_name)
  end
end
