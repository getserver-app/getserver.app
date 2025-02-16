Rails.configuration.stripe = {
  publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
  secret_key: ENV["STRIPE_SECRET_KEY"]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

product_id = Rails.configuration.stripe[:product_id] = "vps"

begin
  @product = Stripe::Product.retrieve({ id: product_id })
rescue Stripe::InvalidRequestError
  @product = Stripe::Product.create(
    id: product_id,
    name: "Virtual Private Server",
    description: "1 vCPU, 1 GB RAM, 25GB NVME Disk",
    active: true,
    default_price_data: {
      unit_amount: 1200, # 12 USD
      currency: "usd",
      recurring: { interval: "month" }
    }
  )
end

Rails.configuration.stripe[:product] = @product
