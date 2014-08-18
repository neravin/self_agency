class AdvertisementsController < ApplicationController
	before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
	
  def index
    @advertisements = Advertisement.all
	end

  def create
    @advertisement = Advertisement.new(advertisement_params)
    if @advertisement.save
      current_client.advertisements << @advertisement
      redirect_to current_client
    else
      redirect_to current_client
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
    params.require(:advertisement).permit(:name, :description, :price, :city, :address, :date, :start_hour, :end_hour)
  end

end