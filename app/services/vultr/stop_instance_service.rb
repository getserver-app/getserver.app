module Vultr
  class StopInstanceService < Vultr::BaseService
    def execute
      vultr_client.instances.halt(instance_id: @instance_id)
    end
  end
end
