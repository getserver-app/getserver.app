module Action
  class StopService < Action::BaseService
    def execute
      Vultr::StopInstanceService.new(instance_id: @server.provider_identifier).execute
      @flash.notice = "Successfully stopped #{@server.name}. Note, you will still be charged for stopped servers."
    end
  end
end
