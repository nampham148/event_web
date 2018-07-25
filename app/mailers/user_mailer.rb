class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.omniauth_password.subject
  #
  def omniauth_password(user, password)
    @user = user
    @password = password
    mail to: user.email, subject: "Welcome to Event Hoster"
  end
end
