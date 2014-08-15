class PasswordResetsController < ApplicationController
  skip_before_action :authorize
  def new 
  end

  def create
    client = Client.find_by(email: params[:email])
    if client
      client.generate_password_reset_token!
      client.update_attribute(:password_reset_sent_at, Time.zone.now)
      Notifier.password_reset(client).deliver
      flash[:success] = "Инструкции по восстановлению пароля отправлены на почту"
      redirect_to home_path
    else
      flash.now[:notice] = "Email не найден"
      render action: 'new'
    end
  end

  def edit
    @client = Client.find_by(password_reset_token: params[:id])
    if @client
    else
      render file: 'public/404.html', status: :not_found
    end
  end

  def update
    @client = Client.find_by(password_reset_token: params[:id])
    if @client.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Срок восстановления пароля истёк"
    elsif @client && @client.update_attributes(client_params)
      @client.update_attribute(:password_reset_token, nil)
      sign_in @client
      redirect_to home_path, success: "Ваш пароль упешно изменен" 
    else
      flash.now[:notice] = "Токен пароля не найден"
      render action: 'edit'
    end
  end

  private

    def client_params
      params.require(:client).permit(:password, :password_confirmation)
    end
end
 