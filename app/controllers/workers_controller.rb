class WorkersController < ApplicationController
	before_action :set_worker, only: [:show, :edit, :update, :destroy]
	def index
		@workers = Worker.all
	end

	def new
		@worker = Worker.new
	end

	def create
		@worker = Worker.new(worker_params)
		respond_to do |format|
			if @worker.save
	      current_client.workers << @worker
	      #flash[:success] = "Объявление добавлено";
	      format.html { redirect_to current_client }
	      format.json { render :show, status: :created, location: @worker }
	    else
	      format.html { render :new }
	      format.json { render json: @worker.errors, status: :unprocessable_entity }
	    end
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