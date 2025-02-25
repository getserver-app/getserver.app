module Action
  class UndoService < Action::BaseService
    def execute
      begin
        @subscription = Stripe::Subscription.retrieve(@server.stripe_subscription_id)
        Stripe::Subscription.resume(@subscription.id, { billing_cycle_anchor: "unchanged" })
        ServerDeletion.where(server: @server).destroy_all
        @flash.notice = "Successfully deleted #{@server.name}"
      rescue => e
        @logger.error(e)
        @flash.alert = "Something went wrong deleting your server. If this continue please send us an email at: support@getserver.app"
      end
    end
  end
end
