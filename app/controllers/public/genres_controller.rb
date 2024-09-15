class Public::GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:show, :destroy]
  before_action :authorize_user!, only: [:show, :destroy]

  def show
    @title = @genre.title
    @category = @title.category
    @contents = @genre.contents
    @content = Content.new
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_contents = @genre.contents.sort_contents(@sort_order)
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
    @genre.destroy
    redirect_back(fallback_location: root_path, notice: 'ジャンルが削除されました。')
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
  end

  def authorize_user!
    @title = @genre.title
    @category = @title.category
    # current_user がカテゴリの所有者であることを確認
    redirect_to root_path, alert: 'アクセス権がありません' unless @category.user == current_user
  end

  def genre_params
    params.require(:genre).permit(:genre_name)
  end
end
