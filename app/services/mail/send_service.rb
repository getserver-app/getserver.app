module Mail
  class SendService < Mail::BaseService
    def execute
      messages_params = {
        from: VERIFICATION_EMAIL_FROM,
        to: @to,
        subject: "Please verify your email",
        text: @body
      }
      mg_client.send_message(EMAIL_DOMAIN, messages_params)
    end
  end
end
