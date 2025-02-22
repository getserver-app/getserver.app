module Vultr
  class DeleteInstanceService < Vultr::BaseService
    def execute
      vultr_client.instances.delete(instance_id: @instance_id)
    end
  end
end
