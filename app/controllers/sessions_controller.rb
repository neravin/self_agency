class SessionsController < ApplicationController
  skip_before_action :authorize
  def new  
  end

  def create
    client = Client.find_by(email: params[:session_user][:email].downcase)
    
    if client && client.authenticate(params[:session_user][:password]) 
      # Sign the client in and redirect to the client's show page.
      if !client.active?
        redirect_to home_path, notice: "Вы ещё не активировали пользователя"
      else
        sign_in client
        redirect_back_or client
      end
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end  
  end

  def destroy
    sign_out
    redirect_to home_path
  end
end
