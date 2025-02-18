class SendEmailService
    def execute(to:, responsibility:)
        mg_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])

        if responsibility == "verification"
            messages_params = {
                from: "no-reply@getserver.app",
                to: to,
                subject: "Please verify your email",
                text: "This is a test email."
            }
            mg_client.send_message("getserver.app", messages_params)
        end

    end
end