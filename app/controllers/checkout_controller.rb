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

    server_name = "#{SERVER_ADJECTIVES.sample.capitalize}#{SERVER_NAMES.sample}"

    vultr_instance = Vultr::CreateInstanceService.new(
      user_id: session_user.id,
      hostname: server_name,
      stripe_id: stripe_session.subscription,
      server_id: server_id,
    ).execute

    server = Server.new({
      name: server_name,
      internal_id: server_id,
      user_id: session_user.id,
      provider_identifier: vultr_instance.id,
      provider_plan_identifier: vultr_instance.plan,
      provider_os_identifier: vultr_instance.os,
      provider_region_identifier: vultr_instance.region,
      stripe_subscription_id: stripe_session.subscription
    })
    server.save!

    Mail::SendService.new(
      responsibility: "credentials",
      to: session_user.email,
      body: %Q(
      Thank you for creating a server with getserver.app!
      <br>
      Server Credentials:
      <br>
      <b>Username:</b> #{vultr_instance.user_scheme}<br>
      <b>Password:</b> #{vultr_instance.default_password}<br>
      <br>
      To login, use <pre><code>ssh #{vultr_instance.user_scheme}@[YOUR SERVERS IP]</code></pre>, you can find your servers IP by going to your dashboard.
      <br>
      )
    ).execute
    session.delete(:stripe_checkout)
    flash.notice = "Thank you! Your server is spinning up, please check your email in the next few minutes for connection credentials"
    redirect_to "/dashboard"
  end
end
