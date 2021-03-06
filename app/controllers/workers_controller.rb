# encoding: utf-8
class WorkersController < ApplicationController
	skip_before_action :authorize
  before_action :set_worker, only: [:show, :edit, :update, :destroy]
	before_action :correct_worker, only: [:edit, :update, :destroy]

	def index
    category_id = params[:category]
    if category_id
      category = Category.find_by_id(category_id)
      if category
        services_id = category.services.map(&:id)
        buf = Worker.where(:service_id => services_id)
      end
    else
      buf = Worker.all
    end
    if buf
      @workers = buf.page(params[:page]).per_page(3)
    end
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
	      #format.html { redirect_to current_client }
	      #format.json { render :show, status: :created, location: @worker }
        format.json { render json: @worker.to_json(:include => { :service => { :only => :name, :include => {:category => { :only => :name } } } } ), status: :created, location: @worker }
	    else
        format.json { render :json => { :error => @worker.errors.messages }, :status => 500 }
	    end
  	end
	end

	def edit
  end

  def update
    respond_to do |format|
      if @worker.update(worker_params)
        format.json { render json: @worker.to_json(:include => { :service => { :only => :name, :include => {:category => { :only => :name } } } } ), status: :created, location: @worker }
        #format.html { redirect_to current_client, notice: 'Объявление успешно обновлено' }
        #format.json { render :show, status: :ok, location: @worker }
      else
        format.json { render :json => { :error => @worker.errors.messages }, :status => 500 }
        #format.html { render :edit }
        #format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @worker.destroy
    render json: { success: true }
    #respond_to do |format|
      #format.html { redirect_to advertisements_path }
    #end
  end

	def worker_ad
		if p = Worker.find_by_id(params['id'])
      if (p.state == 0)
        p.update_attribute("state", 1)
        render text: "Услуга забронирована. Ожидайте звонок от работника"
        #redirect_back_or ''
      else
        render text: "Услуга не доступна для бронирования"
        #redirect_back_or ''
      end
      #flash[:success] = "Заказ забронирован. Ожидайте звонок от заказчика.#{params[:id]}" 
      #redirect_to ''
    else
      render text: "Такой услуги не существует"
    end
  end

private
	def set_worker
		@worker = Worker.find(params[:id])
	end
	
	def worker_params
		params.require(:worker).permit(
      :name, 
      :description, 
      :price, 
      :city, 
      :address,
      :service_id)
	end

	def correct_worker
    if current_client
      redirect_to('') unless current_client.workers.find_by_id(params[:id])
    else
      redirect_to('')
    end
  end

end