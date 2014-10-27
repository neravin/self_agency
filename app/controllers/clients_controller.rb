# encoding: utf-8
class ClientsController < ApplicationController
  skip_before_action :authorize
  before_action :signed_in_client, only: [:show, :edit, :update, :specialization, :edit_specializations]
  before_action :correct_client,   only: [:edit, :update]
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :is_worker, only: [:specialization]
  
  # GET /clients/new
  def new
    @client = Client.new
  end

  def index
    @search = Client.search(params[:q])
    @client = @search.result
  end

  def edit
  end

  def show
    @type_user = @client.type_user
    @with_categories = 1
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
        #flash[:success] = "Вам было отправлено письмо на почту.";
        format.html { redirect_to '', notice: "Пожалуйста, #{@client.name}, зайдите на почту и подтвердите её." }
        format.js { render :nothing => true }
        format.json { render json: @client, status: :created, location: @client }
        #message = { "message": "Письмо с дальнейшими инструкциями отправлено на почту." }
        #format.json { render :json => message }
      else
        #format.html { render :new }
        #format.json { render json: @client.errors, status: :unprocessable_entity }
        format.json { render :json => { :error => @client.errors.messages }, :status => 500 }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to admin_routes_index_url }
    end
  end

  def select_category
    respond_to do |format|
      select_services = Service.where("category_id = #{params[:id]}") 
      format.json { render :json => select_services }
    end
  end

  def specialization
    @categories = Category.all
  end

  def edit_specializations
    p = params[:client][:service_ids]
    pams = { :client => {:service_ids => p } }
    respond_to do |format|
      if current_client.update_attributes(pams[:client])
        format.json { render json: current_client, status: :created, location: current_client }
        #render text: "Нельзя отменить"
      else
        #Rails.logger.info(current_client.errors.messages.inspect)
        format.json { render :json => { :error => current_client.errors.messages }, :status => 500 }
      end
    end
  end

  def more_info
    @client = current_client
  end

  def advertisements
    @client = current_client
    @type_user = @client.type_user
    @with_categories = 0
    if @client.type_user == 0
      # customer
      @advertisements = @client.advertisements
    else
      redirect_to '/'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :email, :password, :password_confirmation, :photo, :phone, :type_user)
    end

    def client_spec_params
      params.require(:client).permit({:service_ids => []})
    end

    # Before filters

    def signed_in_client
      unless signed_in?
        store_location
        redirect_to '/', notice: "Please sign in." unless signed_in?
      end
    end

    def correct_client
      @client = Client.find(params[:id])
      redirect_to('') unless current_client?(@client)
    end

    def is_worker
      redirect_to('') unless current_client.type_user == 1
    end
end
