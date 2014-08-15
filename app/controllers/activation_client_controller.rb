class ActivationClientController < ApplicationController
  skip_before_action :authorize

  def edit
    if params[:id]
      @client = Client.find_by(confirmation_token: params[:id])
      if @client && !@client.active?
        if @client.confirmation_token_sent_at < 12.hours.ago
          redirect_to registration_path, :alert => "Срок подтверждения регистрации истёк. Зарегистрируйтесь снова"
        else
          @client.update_attribute(:confirmation_token, nil)
          @client.activate!
          sign_in @client
          redirect_to home_path, success: "Вы зарегистрировались"
        end 
      else
        render file: 'public/404.html', status: :not_found
      end
    else
      redirect_to home_path
    end
  end

end
