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

    latest_verification_attempt = Email.where(
      responsibility: "verification",
      email: @email
    ).order(created_at: :desc).first

    if latest_verification_attempt.created_at > 5.minutes.ago
      flash.alert = "Please allow at least 5 minutes to pass before you try to verify again."
      return redirect_to "/"
    end

    @user = User.find_by(email: @email)

    if @user.nil?
      customer = Stripe::Customer.create(email: @email)
      @user = User.new(email: @email, stripe_id: customer.id, verified: false)
      @user.save
    end

    session[:user_id] = @user.id

    if session_user_verified
      return redirect_to "/dashboard"
    end

    verification_path = SecureRandom.uuid

    @verification_email = Mail::SendService.new(
      to: @email,
      responsibility: "verification",
      body: %Q(
Please click the following link to #{@user.verified ? "login to" : "rent a vps from"} getserver.app:
<br>
<a href="https://getserver.app/verify/#{verification_path}">https://getserver.app/verify/#{verification_path}</a>
<br>
Do not share this link with anybody.
<br>
      ).strip
    ).execute

    @verification = Verification.create(
      path: verification_path,
      email_id: @verification_email.id,
      user_id: @user.id
    )

    redirect_to "/"
  end
end
