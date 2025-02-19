module Vultr
  class BaseService < BaseService
    def vultr_client
      if @vultr_client.nil?
        return @vultr_client = Vultr::Client.new(api_key: ENV["VULTR_API_KEY"])
      end
      @vultr_client
    end
  end
end
