module Vultr
  class RestartInstanceService < Vultr::BaseService
    def execute
      vultr_client.instances.reboot(instance_id: @instance_id)
    end
  end
end
