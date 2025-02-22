class DashboardController < ApplicationController
  before_action :require_verified_login_session

  def dashboard
    @user = session_user
    @servers = @user.servers
  end

  def action
    @action = params["cmd"]
    @server = Server.find(params["server"])

    if session_user != @server.user.id
      redirect_to "/dashboard"
    end

    case @action
    when "New"
    when "Restart"
      Vultr::RestartInstanceService.new(instance_id: @server.provider_identifier).execute
      flash.notice = "Restarting #{@server.name}. This can take a few minutes."
    when "Stop"
      Vultr::StopInstanceService.new(instance_id: @server.provider_identifier).execute
      flash.notice = "Successfully stopped #{@server.name}. Note, you will still be charged for stopped servers."
    when "Delete"
      begin
        @subscription = Stripe::Subscription.retrieve(@server.stripe_subscription_id)
        ServerDeletion.new(
          server: @server,
          delete_at: Time.at(Integer(@subscription.current_period_end)).to_datetime
        )
        Stripe::Subscription.cancel(@subscription.id)
        flash.notice = "Successfully deleted #{@server.name}"
      rescue e
        logger.error(e)
        flash.alert = "Something went wrong deleting your server. If this continue please send us an email at: support@getserver.app"
        redirect_to "/dashboard"
      end
    when "Undo"
      begin
        @subscription = Stripe::Subscription.retrieve(@server.stripe_subscription_id)
        Stripe::Subscription.resume(@subscription.id, { billing_cycle_anchor: "unchanged" })
        ServerDeletion.where(server: @server).destroy_all
        flash.notice = "Successfully deleted #{@server.name}"
      rescue e
        logger.error(e)
        flash.alert = "Something went wrong deleting your server. If this continue please send us an email at: support@getserver.app"
        redirect_to "/dashboard"
      end
    end

    redirect_to "/dashboard"
  end
end
