module UserHelper
  def session_user
    if session[:user_id].nil?
      return nil
    end
    User.find({id: session[:user_id]})
  end
end
