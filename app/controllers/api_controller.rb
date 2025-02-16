class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check_email
    email = params[:email]
    validated_params = params.require(:email)
    @user = User.find_by(email: email)

    if @user.nil?
      render json: { button_txt: "Rent a VPS" }, status: :not_found
      return
    end

    render json: { button_txt: "Go to dashboard" }, status: :ok
  end
end
