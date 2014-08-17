class AdvertisementsController < ApplicationController

	def new
		@advertisement = Advertisement.new
	end
	
	def index
    @advertisements = Advertisement.all
	end


end