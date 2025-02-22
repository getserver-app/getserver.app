class DashboardController < ApplicationController
  before_action :require_verified_login_session

  def dashboard
    @user = session_user
    @servers = @user.servers

  end

  def action
    @action = params["cmd"]
    @server = Server.find_by_id(params["server"])

    if @action == "Restart"
      Vultr::BaseService.new.vultr_client.instances.reboot(instance_id: @server.provider_identifier)
      flash.notice = "Successfully restarted #{@server.name}"
    end

    if @action == "Stop"
      Vultr::BaseService.new.vultr_client.instances.halt(instance_id: @server.provider_identifier)
      flash.notice = "Successfully stopped #{@server.name}"
    end

    if @action == "Delete"
      Vultr::BaseService.new.vultr_client.instances.delete(instance_id: @server.provider_identifier)
      flash.notice = "Successfully deleted #{@server.name}"
    end

    redirect_to "/dashboard"
  end

end
