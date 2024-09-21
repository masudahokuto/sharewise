module ApplicationHelper
  # 今日登録したcontent
  def today_contents
    Content.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
  # 機能登録したcontent
  def yesterday_contents
    Content.where(created_at: Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
  end

  def content_link(content)
    category = content.genre.title.category
    title = content.genre.title
    genre = content.genre
    link_to content.content_name, category_title_genre_content_path(category, title, genre, content)
  end
end
