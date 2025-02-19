module Vultr
  class DeleteInstanceService < Vultr::BaseService
    def execute
      vultr_client.delete(instance_id: @id)
    end
  end
end
