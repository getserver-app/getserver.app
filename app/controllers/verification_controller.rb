class VerificationController < ApplicationController

    def verify
        @verification_path = params["path"]
        @verification = Verification.where(path: @verify_path)
        @user = User.where(user_id: session[:user_id])
   
        if @user.nil?
            return redirect_to "/"
        end

        

    end

end
