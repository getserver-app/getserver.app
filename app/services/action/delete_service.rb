module Action
  class DeleteService < Action::BaseService
    def execute
      begin
        unless @server.server_deletion.nil?
          @flash.notice = "#{server.name} is already scheduled to be deleted at #{@server.server_deletion.delete_at}"
          return redirect_to "/dashboard"
        end
        @subscription = Stripe::Subscription.retrieve(@server.stripe_subscription_id)
        ServerDeletion.new(
          server: @server,
          delete_at: Time.at(Integer(@subscription.current_period_end)).to_datetime
        ).save!
        Stripe::Subscription.cancel(@subscription.id)
        @flash.notice = "Successfully deleted #{@server.name}"
      rescue => e
        @logger.error(e)
        @flash.alert = "Something went wrong deleting your server. If this continue please send us an email at: support@getserver.app"
      end
    end
  end
end