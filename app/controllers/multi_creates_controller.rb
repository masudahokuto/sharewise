class MultiCreatesController < ApplicationController
  def new
    @user = current_user
    @category = Category.new
    @title = @category.titles.build
    @genre = @title.genres.build
    @content = @genre.contents.build
    @include_clock_js = true # 時計機能
    @links = current_user.links
  end

  def create
    ActiveRecord::Base.transaction do
      @category = Category.new(category_params)
      @category.user = current_user
      @category.save!

      # タイトル、ジャンル、コンテンツを関連付けて作成
      @title = @category.titles.create!(title_params)
      @genre = @title.genres.create!(genre_params)
      @content = @genre.contents.create!(content_params)
    end

    flash[:success] = "もくじ１～４と内容を作成しました。"
    redirect_to category_title_genre_content_path(@category, @title, @genre, @content)
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "エラーが発生しました"
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
