# encoding: utf-8
class ClientsController < ApplicationController
  skip_before_action :authorize
  before_action :signed_in_client, only: [:show, :edit, :update]
  before_action :correct_client,   only: [:edit, :update]
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  
  # GET /clients/new
  def new
    @client = Client.new
  end

  def edit
  end

  def show
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
      # Handle a successful update.
      flash[:success] = "Профиль обновлён"
      redirect_to @client
    else
      render 'edit'
    end
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params) 
    respond_to do |format|
      if @client.save
        @client.generate_confirm!
        ConfirmationNotifier.confirmation_token(@client).deliver
        flash[:success] = "Вам было отправлено письмо на почту.";
        format.html { redirect_to '', notice: "Пожалуйста, #{@client.name}, зайдите на почту и подтвердите её." }
        format.json { render :show, status: :created, location: @client }
      else
        #format.html { render :new }
        #format.json { render json: @client.errors, status: :unprocessable_entity }
        format.json { render :json => { :error => @client.errors.full_messages }, :status => 422 }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to admin_routes_index_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :email, :password, :password_confirmation, :photo, :phone)
    end

    # Before filters

    def signed_in_client
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in." unless signed_in?
      end
    end

    def correct_client
      @client = Client.find(params[:id])
      redirect_to('') unless current_client?(@client)
    end
end
