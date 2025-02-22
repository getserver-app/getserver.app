class VerificationController < ApplicationController
  def verify
    @verification = Verification.find_by(path: params["path"])
    @user = session_user

    if @verification.nil? or @verification.created_at <= 1.hours.ago
      return render "invalid", status: 400
    end

    if @user.nil?
      return redirect_to "/"
    end

    if @verification.user.id != @user.id
      return redirect_to "/"
    end


    session[:verified_at] = DateTime.now.strftime("%Q")

    Verification.where(user: @user).destroy_all

    @user.update(verified: true)

    if @user.verified
      return redirect_to "/dashboard"
    end

    redirect_to "/checkout"
  end
end
