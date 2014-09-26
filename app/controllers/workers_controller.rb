# encoding: utf-8
class WorkersController < ApplicationController
	skip_before_action :authorize
  before_action :set_worker, only: [:show, :edit, :update, :destroy]
	before_action :correct_worker, only: [:edit, :update]

	def index
    service_id = params[:service_id]
    if service_id
		  @workers = Worker.
        where("service_id == ?", service_id).
        order("name").
        page(params[:page]).
        per_page(3)
    else
      @workers = Worker.
        order("name").
        page(params[:page]).
        per_page(3)
    end
    
    if params["i_want"]
      if !params["i_want"].empty?
        i_want = Unicode::downcase(params["i_want"])
        service_ids = []

        Service.all.each do |service|
          if Unicode::downcase(service.name).index(i_want)
            service_ids.push(service.id)
          end
        end
        if !service_ids.empty?
          @workers = Worker.
            where(:service_id => service_ids).
            page(params[:page]).
            per_page(3)
        else 
          flash[:error] = "Поиск не дал результатов"
          redirect_to ''
          return
        end
      end
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
        format.json { render json: @worker.to_json(:include => { :service => { :only => :name } } ), status: :created, location: @worker }
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
        format.html { redirect_to current_client, notice: 'Объявление успешно обновлено' }
        #format.json { render :show, status: :ok, location: @worker }
      else
        format.html { render :edit }
        #format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
    end
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