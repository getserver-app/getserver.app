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
      cancel_url: stripe_checkout_cancel_url
    )
    session[:stripe_session] = stripe_session.id
    redirect_to stripe_session.url, allow_other_host: true
  end

  def cancel
    redirect_to "/"
  end

  def success
    # Shit naming, I know...
    stripe_session = session_stripe_session
    if stripe_session.nil?
      redirect_to "/"
    end

    if stripe_session.status != "paid"
      session.delete(:stripe_session)
      return redirect_to "/"
    end

    # TODO: Call Vultr, and spin up an instance
    flash.notice = "Thank you! Your server is spinning up, please check your email in the next few minutes for connection credentials"

    redirect_to "/dashboard"
  end
end
