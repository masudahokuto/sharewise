class MultiCreatesController < ApplicationController
  def new
    @user = current_user
    @category = Category.new
    @title = @category.titles.build
    @genre = @title.genres.build
    @content = @genre.contents.build
    @include_clock_js = true
    @links = Link.all
  end

  def create
    ActiveRecord::Base.transaction do
      @category = Category.new(category_params)
      @category.user = current_user
      @category.save!

      @title = @category.titles.create!(title_params)
      @genre = @title.genres.create!(genre_params)
      @content = @genre.contents.create!(content_params)
    end

    redirect_to category_title_genre_content_path(@category, @title, @genre, @content)
    flash[:success] = "カテゴリー、タイトル、ジャンル、コンテンツを作成しました。"
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "エラーが発生しました: #{e.message}"
    redirect_back(fallback_location: root_path)
  end

  private

  def category_params
    params.require(:category).permit(:category_name)
  end

  def title_params
    params.require(:title).permit(:title_name)
  end

  def genre_params
    params.require(:genre).permit(:genre_name)
  end

  def content_params
    params.require(:content).permit(:content_name, :body, images: [])
  end
end
