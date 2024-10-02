class Public::GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:show, :destroy, :update]
  before_action :authorize_user!, only: [:show, :destroy]

  def show
    @title = @genre.title  # ジャンルに関するタイトルを取得
    @category = @title.category  # タイトルに関するカテゴリを取得
    @contents = @genre.contents  # ジャンルに関するコンテンツを取得
    @content = Content.new
    @sort_order = params[:sort_order] || 'created_at'  # ソート順を取得
    @sorted_contents = @genre.contents.sort_contents(@sort_order)  # コンテンツをソート
  end

  def create
    @title = Title.find(params[:title_id])
    @genre = @title.genres.new(genre_params)

    if @genre.save
      flash[:success] = "もくじを作成しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "エラーが発生しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @title = Title.find(params[:title_id])
    @category = Category.find(params[:category_id])

    if @genre.update(genre_params)
      respond_to do |format|
        format.js
        format.html { redirect_to category_title_path(@category, @title), notice: 'もくじが更新されました。' }
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
    @genre.destro
    redirect_back(fallback_location: root_path, notice: 'もくじが削除されました。')
  end

  private

  # ジャンルをセットするメソッド
  def set_genre
    @genre = Genre.find_by(id: params[:id])
    if @genre.nil?
      redirect_to root_path, alert: 'ジャンルが見つかりません。'
    end
  end

  # ユーザーのアクセス権を確認するメソッド
  def authorize_user!
    @title = @genre.title  # ジャンルに関連するタイトルを取得
    @category = @title.category  # タイトルに関連するカテゴリを取得
    # current_user がカテゴリの所有者であることを確認
    redirect_to root_path, alert: 'アクセス権がありません' unless @category.user == current_user  # アクセス権がない場合はリダイレクト
  end

  # ジャンルのパラメータを許可するトメソッド
  def genre_params
    params.require(:genre).permit(:genre_name)
  end
end
