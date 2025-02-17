class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check_email
    if params[:email] !~ EMAIL_REGEXP
      return render json: {}, status: :bad_request
    end

    @user = User.find_by(email: params[:email])

    if @user.nil?
      render json: { button_txt: "Rent a VPS" }, status: :not_found
      return
    end

    render json: { button_txt: "Go to dashboard" }, status: :ok
  end

  def send_email
  
  end

end
