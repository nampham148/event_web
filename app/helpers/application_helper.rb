module ApplicationHelper
  def logged_in
    unless user_signed_in?
      redirect_to new_user_session_url
    end
  end
end
