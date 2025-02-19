class CoreController < ApplicationController
  rate_limit to: 3,
    within: 2.minute,
    store: cache_store,
    by: -> { request.domain },
    with: -> { redirect_to "index", alert: "Too many verification attemps!, Please try again later." },
    only: :enter

  def index
  end

  def enter
    @email = params["email"]

    verification_attempts = Email.where(
      responsibility: "verification",
      email: @email, created_at: Time.parse("12am")..Time.parse("11:59pm")
    ).count
    if verification_attempts > 5
      flash.alert = "Rate limited."
      return redirect_to "/"
    end

    @user = User.find_by(email: @email)

    if @user.nil?
      customer = Stripe::Customer.create(email: @email)
      @user = User.create(email: @email, stripe_id: customer.id)
      flash.notice = "Thanks for signing up. Check your email in the next few minutes to get your VPS."
    else
      flash.notice = "Check your email in the next few minutes to finish logging in."
    end

    session[:user_id] = @user.id
    session[:verification_attempts] = verification_attempts

    Email.create(
      responsibility: "verification",
      email: @email,
    )

    Mail::SendService.new(to: @email, responsibility: "verification").execute()

    redirect_to "/"
  end
end
