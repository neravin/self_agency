class AdvertisementsController < ApplicationController
  skip_before_action :authorize
	before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
	before_action :correct_advertisement, only: [:edit, :update]

  def index
    @advertisements = Advertisement.order("name").page(params[:page]).per_page(3)
	end

  def new
    @advertisement = Advertisement.new
  end

  def create
    @advertisement = Advertisement.new(advertisement_params)
    respond_to do |format|
      if @advertisement.save
        current_client.advertisements << @advertisement
        flash[:success] = "Объявление добавлено";
        format.html { redirect_to current_client }
        #format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        #format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.html { redirect_to current_client, notice: 'Объявление успешно обновлено' }
        #format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        #format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  def perform_ad
    if p = Advertisement.find_by_id(params['id'])
      if (p.state == 0)
        p.update_attribute("state", 1)
        render text: "Объявление забронировано. Ожидайте звонок от заказчика"
        #redirect_back_or ''
      else
        render text: "Объявление не доступно для бронирования"
        #redirect_back_or ''
      end
      #flash[:success] = "Заказ забронирован. Ожидайте звонок от заказчика.#{params[:id]}" 
      #redirect_to ''
    else
      render text: "Такого объявления не существует"
    end
  end

private
  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

  def advertisement_params
    params.require(:advertisement).permit(
      :description, 
      :price, 
      :city, 
      :address, 
      :date, 
      :start_hour, 
      :end_hour,
      :service_id)
  end

  def correct_advertisement
    if current_client
      redirect_to('') unless current_client.advertisements.find_by_id(params[:id])
    else
      redirect_to('')
    end
  end
end