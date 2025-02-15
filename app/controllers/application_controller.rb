class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
  end

  def enter
    @email = params["email"]

    @user = User.find_by email: @email

    # Redirect to stripe checkout
    if @user.nil?
      customer = Stripe::Customer.create(email: @email)
      @user = User.new(email: @email, stripe_id: customer.id)
    end
  end
end
