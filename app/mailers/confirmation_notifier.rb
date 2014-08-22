class ConfirmationNotifier < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  default from: "from@example.com"

  def confirmation_token(client)
    @client = client
    mail(to: "#{client.name} <#{client.email}>",
        subject: "Подтверждение пароля")
  end
end
