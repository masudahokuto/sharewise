class Public::GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:show, :destroy, :update]
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

  def update
    @title = Title.find(params[:title_id])
    @category = Category.find(params[:category_id])
    if @genre.update(genre_params)
      respond_to do |format|
        format.js # JavaScriptでレスポンスを返す
        format.html { redirect_to category_title_path(@category, @title), notice: 'カテゴリー名が更新されました。' }
      end
    else
      respond_to do |format|
        format.js
        format.html { render :show }
      end
    end
  end

  def destroy
    @genre.destroy
    redirect_back(fallback_location: root_path, notice: 'ジャンルが削除されました。')
  end

  private

  def set_genre
    @genre = Genre.find_by(id: params[:id])
    if @genre.nil?
      redirect_to root_path, alert: 'ジャンルが見つかりません。'
    end
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
