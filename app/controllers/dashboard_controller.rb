class DashboardController < ApplicationController
  before_action :require_verified_login_session
end
