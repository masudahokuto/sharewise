class Public::ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [:show, :edit, :update, :destroy]  # コンテンツをセット
  before_action :authorize_user!, only: [:show, :update, :destroy]
  before_action :set_category_title_genre, only: [:new, :create]  # カテゴリタイトルジャンルをセット

  def new
    @content = @genre.contents.new
    @user = current_user
    @include_clock_js = true
    @links = current_user.links
  end

  def create
    @content = @genre.contents.new(content_params)

    if @content.save
      flash[:success] = "ページを作成しました"
      handle_redirect_after_create
    else
      flash[:alert] = "エラーが発生しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @genre = @content.genre  # コンテンツのジャンルを取得
    @title = @genre.title  # ジャンルのタイトルを取得
    @category = @title.category  # タイトルのカテゴリを取得
    @user = current_user
  end

  def edit
    @user = current_user
    @include_clock_js = true
    @links = current_user.links
  end

  def update
    if @content.update(content_params)
      redirect_to category_title_genre_content_path(@category, @title, @genre), notice: 'コンテンツが更新されました。'
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

  # カテゴリ、タイトル、ジャンルをセットするプライベートメソッド
  def set_category_title_genre
    @category = Category.find(params[:category_id])  # カテゴリを取得
    @title = @category.titles.find(params[:title_id])  # タイトルを取得
    @genre = @title.genres.find(params[:genre_id])  # ジャンルを取得
  end

  # コンテンツをセットするプライベートメソッド
  def set_content
    @category = Category.find_by(id: params[:category_id])  # カテゴリを取得
    @title = @category.titles.find_by(id: params[:title_id]) if @category  # タイトルを取得
    @genre = @title.genres.find_by(id: params[:genre_id]) if @title  # ジャンルを取得
    @content = @genre.contents.find_by(id: params[:id]) if @genre  # コンテンツを取得
  end

  # ユーザー権限を確認するメソッド
  def authorize_user!
    @genre = @content.genre  # コンテンツのジャンルを取得
    @title = @genre.title  # ジャンルのタイトルを取得
    @category = @title.category  # タイトルのカテゴリを取得
    redirect_to root_path, alert: 'アクセス権がありません' unless @category.user == current_user
  end

  def content_params
    params.require(:content).permit(:content_name, :body, images: [])
  end

  # コンテンツ作成後のリダイレクト処理メソッド
  def handle_redirect_after_create
    if params[:save_and_show]  # 保存して表示する場合
      redirect_to category_title_genre_content_path(@category, @title, @genre, @content)  # コンテンツの詳細ページにリダイレクト
    elsif params[:save_and_new]  # 保存して新規作成する場合
      redirect_to new_category_title_genre_content_path(@category, @title, @genre)
    else
      redirect_to new_category_title_genre_content_path(@category, @title, @genre)
    end
  end
end
