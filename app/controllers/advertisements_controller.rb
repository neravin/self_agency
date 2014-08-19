class AdvertisementsController < ApplicationController
	before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
	
  def index
    @advertisements = Advertisement.order("name").page(params[:page]).per_page(3)
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

private
  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

  def advertisement_params
    params.require(:advertisement).permit(:name, :description, :price, :city, :address, :date, :start_hour, :end_hour)
  end

end