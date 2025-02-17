class Service::VultrCreateInstance < Service::BaseAction
  def execute
    region_id = get_provider_region_id
    os_id = get_provier_os_id
    plan_id = get_provider_plan_id

    vultr_instance = vultr_client.instances.create({
      region: region_id,
      plan: plan_id,
      label: @stripe_id + "-" + @server_id,
      os_id: os_id,
      tags: [ @user_id, internal_id ]
    })

    Server.create({
      internal_id: @server_id,
      user_id: @user_id,
      provider_identifier: vultr_instance.id,
      provider_plan_identifier: plan_id,
      provider_os_identifier: os_id,
      provider_region_identifier: region_id,
      stripe_subscription_id: @stripe_id
    })
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
