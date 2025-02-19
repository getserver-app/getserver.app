module Email
    class SendService < BaseService
        def execute
            mg_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])

            if @responsibility == "verification"
                messages_params = {
                    from: VERIFICATION_EMAIL_FROM,
                    to: @to,
                    subject: "Please verify your email",
                    text: "This is a test email."
                }
                mg_client.send_message(EMAIL_DOMAIN, messages_params)
            end
        end
    end
end
