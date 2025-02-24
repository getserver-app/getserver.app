class DashboardController < ApplicationController
  before_action :require_verified_login_session

  def dashboard
    @user = session_user
    @servers = @user.servers
  end

  def action
    @action = params.required(:cmd)

    if @action == "New"
      session[:server_id] = SecureRandom.uuid
      return redirect_to "/checkout"
    end

    @server = Server.find(params.required(:server))

    if session_user.id != @server.user.id
      return redirect_to "/dashboard"
    end

    case @action
    when "Restart"
      Action::RestartService.new(server: @server, flash: flash).execute
    when "Stop"
      Action::StopService.new(server: @server, flash: flash).execute
    when "Delete"
      Action::DeleteService.new(server: @server, flash: flash, logger: logger).execute
    when "Undo"
      Action::UndoService.new(server: @server, flash: flash, logger: logger).execute
    end

    redirect_to "/dashboard"
  end
end
