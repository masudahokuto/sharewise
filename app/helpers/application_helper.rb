module ApplicationHelper
  # 今日登録したcontent
  def today_contents
    if current_user
      Content.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
             .joins(genre: { title: :category })
             .where(categories: { user_id: current_user.id })
    else
      Content.none
    end
  end

  # 昨日登録したcontent
  def yesterday_contents
    if current_user
      Content.where(created_at: Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
             .joins(genre: { title: :category }) # current_userが登録したコンテンツのみ
             .where(categories: { user_id: current_user.id })
    else
      Content.none
    end
  end


  def content_link(content)
    genre = content.genre
    title = genre.title
    category = title.category
    link_to content.content_name, category_title_genre_content_path(category, title, genre, content), data: { turbolinks: false }
  end
end
