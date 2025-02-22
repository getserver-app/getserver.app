module Vultr
  class RestartInstanceService
    def execute
      vultr_client.instances.reboot(instance_id: @instance_id)
    end
  end
end
