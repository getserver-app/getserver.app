class Server < ApplicationRecord
  belongs_to :user
  has_one :server_deletion, dependent: :destroy

  validates :name, presence: true
  validates :internal_id, presence: true
  validates :provider_identifier, presence: true
  validates :provider_plan_identifier, presence: true
  validates :provider_os_identifier, presence: true
  validates :provider_region_identifier, presence: true
  validates :active, presence: true
  validates :stripe_subscription_id, presence: true

  before_destroy do
    Vultr::DeleteInstanceService.new(instance_id: self.provider_identifier).execute
  end

  def ip
    self.vultr_instance.main_ip
  end

  def vultr_instance
    if @vultr_instance.nil?
      return @vultr_instance = vultr_client.instances.retrieve(instance_id: self.provider_identifier)
    end
    @vultr_instance
  end

  def vultr_client
    if @vultr_client.nil?
      return @vultr_client = Vultr::Client.new(api_key: ENV["VULTR_API_KEY"])
    end
    @vultr_client
  end

  private :vultr_client
end
