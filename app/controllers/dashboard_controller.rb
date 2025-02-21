class DashboardController < ApplicationController
  before_action :require_verified_login_session

  def dashboard
    @user = session_user
    @servers = @user.servers
  end
end
