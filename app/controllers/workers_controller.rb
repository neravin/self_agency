class WorkersController < ApplicationController
	before_action :set_worker, only: [:show, :edit, :update, :destroy]
	before_action :correct_worker, only: [:edit, :update]

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

	def edit
  end

  def update
    respond_to do |format|
      if @worker.update(worker_params)
        format.html { redirect_to current_client, notice: 'Объявление успешно обновлено' }
        #format.json { render :show, status: :ok, location: @worker }
      else
        format.html { render :edit }
        #format.json { render json: @worker.errors, status: :unprocessable_entity }
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

	def correct_worker
    if current_client
      redirect_to('') unless current_client.workers.find_by_id(params[:id])
    else
      redirect_to('')
    end
  end

end