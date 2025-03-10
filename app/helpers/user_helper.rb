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

  def session_user_verified
    if session_user.nil? || !session_user.verified
      return false
    end

    if session[:verified_at].nil?
      return false
    end

    # 8 Hour verified sessions for now
    if Integer(DateTime.now.strftime("%Q")) - Integer(session[:verified_at]) < 3_600_000
      return true
    end

    false
  end
end
