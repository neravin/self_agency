# encoding: utf-8
class ServicesController < ApplicationController

	def new
		@service = Service.new
	end

	def edit
	end

	def create
		@service = Service.new(service_params)
		respond_to do |format|
			if @service.save
				format.html { redirect_to admin_routes_index_url }
			else
				format.html { render :new }
			end
		end
	end
	def update
		respond_to do |format|
      		if @service.update(service_params)
      			format.html { redirect_to @service }
      		else
      			format.html { render :edit }
      		end
      	end
	end

	def destroy
		@service.destroy
		respond_to do |format|
			format.html { redirect_to admin_routes_index_url }
		end

	end

	private
		def service_params
    		params.require(:service).permit(:name)
  		end
end