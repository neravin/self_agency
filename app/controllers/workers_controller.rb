class WorkersController < ApplicationController
	before_action :set_worker, only: [:show, :edit, :update, :destroy]
	def index
		@workers = Worker.all
	end

	def create
		@worker = Worker.new(worker_params)
		if @worker.save
			current_client.workers << @worker
			redirect_to current_client
		else
			redirect_to current_client
		end
	end

	private
		def set_worker
			@worker = Worker.find(params[:id])
		end
		
		def worker_params
			params.require(:worker).permit(:name, :description, :price, :city, :address)
		end

end