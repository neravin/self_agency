# encoding: utf-8
class OfferServicesController < ApplicationController
	before_action :set_offer_service, only: [:show, :edit, :update, :destroy]
	def new
		@offer_service = OfferService.new
	end

	def edit

	end

	def create
		@offer_service = OfferService.new(offer_service_params)
		respond_to do |format|
			if @offer_service.save
				format.html { redirect_to admin_routes_index_url }
			else
				format.html { render :new }
			end
		end
	end

	def update

	end

	def destroy

	end
private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer_service
      @offer_service = OfferService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_service_params
      params.require(:offer_service).permit(:name, :description)
    end

end