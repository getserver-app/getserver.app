class ImplementationController < ApplicationController
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

    session[:user_id] = @user.id;
  end
end
