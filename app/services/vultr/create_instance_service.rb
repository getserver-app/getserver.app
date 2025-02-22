module Vultr
  class CreateInstanceService < Vultr::BaseService
    def execute
      region_id = self.get_provider_region_id
      os_id = self.get_provider_os_id
      plan_id = self.get_provider_plan_id

      vultr_client.instances.create(
        region: region_id,
        plan: plan_id,
        label: @stripe_id + "-" + @server_id,
        os_id: os_id,
        backups: "disabled",
        tags: [ "User #{@user_id}", "Server #{@server_id}", "Stripe #{@stripe_id}" ]
      )
    end

    # Gets the latest Debian image from Vultr.
    def get_provider_os_id
      vultr_client
        .operating_systems
        .list
        .data
        .filter { |os| os.family == "debian" }
        .map(&:id)
        .sort
        .last
    end

    # 1 vCPU, 1 Gb of memory, 25gb storage
    def get_provider_plan_id
      "vc2-1c-1gb"
    end

    # Toronto
    def get_provider_region_id
      "yto"
    end

    private :get_provider_os_id, :get_provider_plan_id, :get_provider_region_id
  end
end
