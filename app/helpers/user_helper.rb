module UserHelper
  def session_user
    if session[:user_id].nil?
      return nil
    end
    begin
      User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      session.delete(:user_id)
      nil
    end
  end
end
