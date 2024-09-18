class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.where(read: false)
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    case notification.notificable_type
    when "Favorite"
      redirect_to post_path(notification.notificable.post_id)
    else
      redirect_to post_path(notification.notificable.post_id)
    end
  end
end
