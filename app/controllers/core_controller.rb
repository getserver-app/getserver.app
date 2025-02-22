class CoreController < ApplicationController
  rate_limit to: 3,
    within: 2.minute,
    store: cache_store,
    by: -> { request.domain },
    with: -> { redirect_to "index", alert: "Too many verification attemps!, Please try again later." },
    only: :enter

  def index
    if session_user_verified
      redirect_to "/dashboard"
    end
  end

  def enter
    @email = params["email"]

    if @email.nil?
      return redirect_to "/"
    end

    verification_attempts = Email.where(
      responsibility: "verification",
      email: @email, created_at: Time.parse("12am")..Time.parse("11:59pm")
    ).count
    if verification_attempts > 5
      flash.alert = "Rate limited. Try again later."
      return redirect_to "/"
    end

    @user = User.find_by(email: @email)

    if @user.nil?
      customer = Stripe::Customer.create(email: @email)
      @user = User.new(email: @email, stripe_id: customer.id, verified: false)
      @user.save
      flash.notice = "Thanks for signing up. Check your email in the next few minutes to get your VPS."
    else
      flash.notice = "Check your email in the next few minutes to finish logging in."
    end

    session[:user_id] = @user.id

    if session_user_verified
      return redirect_to "/dashboard"
    end

    @verification_email = Mail::SendService.new(
      to: @email,
      responsibility: "verification",
      # is the @user.verified necessary if we're sending the verification link?
      body: %Q(
Please click the following link to #{@user.verified ? "login to" : "rent a vps from"} getserver.app:
<br>
<a href="https://getserver.app/verify/#{@verification.path}">https://getserver.app/verify/#{@verification.path}</a>
<br>
Do not share this link with anybody.
<br>
      ).strip
    ).execute

    @verification = Verification.create(
      path: SecureRandom.uuid,
      email_id: @verification_email.id,
      user_id: @user.id
    )

    redirect_to "/"
  end
end
