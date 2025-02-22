class CheckoutController < ApplicationController
  before_action :require_verified_login_session

  def checkout
    stripe_session = Stripe::Checkout::Session.create(
      customer: session_user.stripe_id,
      payment_method_types: [ "card" ],
      line_items: [ { price: stripe_product.default_price, quantity: 1 } ],
      mode: "subscription",
      success_url: stripe_checkout_success_url,
      cancel_url: stripe_checkout_cancel_url,
      metadata: {
        server_id: SecureRandom.uuid
      }
    )
    session[:stripe_checkout] = stripe_session.id
    redirect_to stripe_session.url, allow_other_host: true
  end

  def cancel
    session.clear
    redirect_to "/"
  end

  def success
    stripe_session = session_stripe_checkout
    if stripe_session.nil? or session_user.nil?
      return redirect_to "/"
    end

    if stripe_session.payment_status != "paid"
      session.delete(:stripe_session)
      return redirect_to stripe_session.url, allow_other_host: true
    end

    server_id = stripe_session.metadata[:server_id]

    vultr_instance = Vultr::CreateInstanceService.new(
      user_id: session_user.id,
      stripe_id: stripe_session.subscription,
      server_id: server_id
    ).execute

    Server.create({
      internal_id: server_id,
      user_id: session_user.id,
      provider_identifier: vultr_instance.id,
      provider_plan_identifier: vultr_instance.plan,
      provider_os_identifier: vultr_instance.os,
      provider_region_identifier: vultr_instance.region,
      stripe_subscription_id: @stripe_id
    })

    server = Server.find_by(internal_id: server_id)

    if server.nil?
      flash.notice = "There has been an issue creating your server."
    else
      flash.notice = "Thank you! Your server is spinning up, please check your email in the next few minutes for connection credentials"
    end
    
    redirect_to "/dashboard"
  end
end
