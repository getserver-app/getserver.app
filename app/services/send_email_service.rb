class SendEmailService
    def execute()
        mg_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])

        messages_params = {
            from: "no-reply@getserver.app",
            to: "gabriel.gavrilov02@gmail.com",
            subject: "Test email",
            text: "This is a test email."
        }

        mg_client.send_message("getserver.app", messages_params)

    end
end