class ApplicationController < ActionController::Base
  include StripeHelper
  include UserHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def require_verified_login_session
    if !session_user_verified
      session.clear
      flash[:alert] = "You need to login to view that page."
      redirect_to "/"
    end
  end

  protected :require_valid_user
end
