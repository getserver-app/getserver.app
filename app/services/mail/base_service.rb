module Mail
  class BaseService < BaseService
    def mg_client
      if @mg_client.nil?
        return @mg_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])
      end
      @mg_client
    end
  end
end
