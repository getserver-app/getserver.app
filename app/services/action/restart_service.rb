module Action
  class RestartService < Action::BaseService
    def execute
      Vultr::RestartInstanceService.new(instance_id: @server.provider_identifier).execute
      @flash.notice = "Restarting #{@server.name}. This can take a few minutes."
    end
  end
end
