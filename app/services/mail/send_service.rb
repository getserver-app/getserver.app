module Mail
  class SendService < Mail::BaseService
    def execute
      responsiblities = {
        verification: "Please verify your login",
        credentials: "Credentials for your new instance"
      }

      if @subject.nil? && @responsibility.nil?
        raise "You cannot send an email without a responsibility, and a subject."
      end

      if @subject.nil?
        @subject = responsiblities[@responsibility.to_sym]
      end

      messages_params = {
        from: VERIFICATION_EMAIL_FROM,
        to: @to,
        subject: @subject,
        html: @body
      }

      mg_client.send_message(EMAIL_DOMAIN, messages_params)

      Email.create(
        responsibility: @responsibility,
        email: @to
      )
    end
  end
end
