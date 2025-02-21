class VerificationController < ApplicationController
    def verify
        @verification = Verification.find_by(path: params["path"])
        @user = session_user
        if @verification.nil? or @user.nil?
            return redirect_to "/"
        end

        session[:verified_at] = DateTime.now.strftime("%Q")

        if @user.verified
            return redirect_to "/dashboard"
        end

        User.find_by_id(session[:user_id]).update(verified: true)
    end
end
