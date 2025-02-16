module StripeHelper
  def session_stripe_checkout
    if session[:stripe_checkout].nil?
      return nil
    end

    begin
      Stripe::Checkout::Session.retrieve(session[:stripe_checkout])
    rescue
      session.delete(:stripe_checkout)
      nil
    end
  end

  def stripe_product
    if @stripe_product.nil?
      return @stripe_product = Stripe::Product.retrieve(Rails.configuration.stripe[:product_id])
    end
    @stripe_product
  end

  def stripe_checkout_success_url
    if Rails.env.production?
      "https://getserver.app/checkout/success"
    else
      "http://localhost:3000/checkout/success"
    end
  end

  def stripe_checkout_cancel_url
    if Rails.env.production?
      "https://getserver.app/checkout/cancel"
    else
      "http://localhost:3000/checkout/cancel"
    end
  end
end
