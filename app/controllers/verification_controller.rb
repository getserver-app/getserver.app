class VerificationController < ApplicationController

    def verify
        @verification = Verification.find_by(path: params["path"])
        @user = User.find_by_id(session[:user_id])
   
        if @user.nil?
            return redirect_to "/"
        end

        User.find_by_id(session[:user_id]).update(verified: true)

    end

end
