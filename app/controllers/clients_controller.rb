class ClientsController < ApplicationController
  skip_before_action :authorize#, only: :composition
  before_action :signed_in_client, only: [:show, :edit, :update]
  before_action :correct_client,   only: [:show, :edit, :update]

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
    @favorite = Favorite.new()
    respond_to do |format|
      if (@client.save && @favorite.save)
        @favorite.update_attribute("client_id", @client.id)
        @client.generate_confirm!
        ConfirmationNotifier.confirmation_token(@client).deliver
        flash[:success] = "Добро пожаловать в интернет магазин";
        format.html { redirect_to home_path, notice: "Пользователь #{@client.name} был успешно создан." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :email, :password, :password_confirmation)
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
      redirect_to(home_path) unless current_client?(@client)
    end
end
