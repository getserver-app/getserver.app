class Server < ApplicationRecord
  belongs_to :user
  before_create do
    self.name = generate_name
  end

  def ip
    self.vultr_instance.ip
  end

  def vultr_instance
    if @vultr_instance.nil?
      return @vultr_instance = vultr_client.retrieve(instance_id: self.provider_identifier)
    end
    @vultr_instance
  end

  def vultr_client
    if @vultr_client.nil?
      return @vultr_client = Vultr::Client.new(api_key: ENV["VULTR_API_KEY"])
    end
    @vultr_client
  end

  def generate_name
    "#{SERVER_ADJECTIVES.sample.capitalize}#{SERVER_NAMES.sample}"
  end

  private :generate_name, :vultr_client
end
