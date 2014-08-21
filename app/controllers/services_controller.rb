class ServicesController < ApplicationController

	def new
		@service = Service.new(service_params)
	end
end