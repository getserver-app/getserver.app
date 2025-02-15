class ApiController < ApplicationController
  def check_email
    validated_params = params.require(:email)
    @user = User.find_by(validated_params)

    if @user.nil?
      render json: { button_txt: "Rent a VPS" }, status: :not_found
    end

    render json: { button_txt: "Go to dashboard" }, status: :ok
  end
end
