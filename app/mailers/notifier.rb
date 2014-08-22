class Notifier < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  default from: "from@example.com"

  def password_reset(client)
    @client = client
    mail(to: "#{client.name} <#{client.email}>",
        subject: "Восстановление пароля")
  end
end
