class VerificationController < ApplicationController

    def verify
        @id = session[:user_id]
        # @verification_path = params["path"]
        # @verification = Verification.find_by(path: @verify_path)
        # @user = User.find_by_id(session[:user_id])
   
        # if @user.nil?
        #     return redirect_to "/"
        # end

        

    end

end
