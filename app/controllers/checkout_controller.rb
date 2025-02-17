class CheckoutController < ApplicationController
  def checkout
    if session_user.nil?
      redirect_to "/"
    end

    stripe_session = Stripe::Checkout::Session.create(
      customer: session_user.stripe_id,
      payment_method_types: [ "card" ],
      line_items: [ { price: stripe_product.default_price.id, quantity: 1 } ],
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
    session.delete(:stripe_session)
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
    VultrCreateInstance.new(
      user_id: session_user.id,
      stripe_id: stripe_session.subscription.id,
      server_id: server_id
    ).execute

    flash.notice = "Thank you! Your server is spinning up, please check your email in the next few minutes for connection credentials"

    redirect_to "/dashboard"
  end
end
