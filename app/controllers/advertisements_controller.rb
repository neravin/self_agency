# encoding: utf-8
class AdvertisementsController < ApplicationController
  skip_before_action :authorize
	before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
	before_action :correct_advertisement, only: [:edit, :update]


  def index
    ad_service_id = params[:advertisement]
    worker_service_id = params[:worker]

    if worker_service_id
      if worker_service_id[:service_id] != ''
        worker_service_id = worker_service_id[:service_id]
        redirect_to :controller => 'workers', :action => 'index', :service_id => worker_service_id
      end
    end

    if ad_service_id
      if ad_service_id[:service_id] != ''
      ad_service_id = ad_service_id[:service_id]
      @advertisements = Advertisement.
        where("service_id == ?", ad_service_id).
        order("date DESC").
        order("start_hour DESC").
        page(params[:page]).
        per_page(3)
      else
        @advertisements = Advertisement.
          order("date DESC").
          order("start_hour DESC").
          page(params[:page]).
          per_page(3)
      end
    else
      @advertisements = Advertisement.
        order("date DESC").
        order("start_hour DESC").
        page(params[:page]).
        per_page(3)
    end


    if params["i-want"] && params["i-can"]
      if params["i-want"].empty? && params["i-can"].empty?
        flash[:error] = "Поиск не дал результатов"
        redirect_to ''
        return
      end
    end
    if params["i-want"] 
      if !params["i-want"].empty?
        redirect_to :controller => 'workers', :action => 'index', :i_want => params["i-want"]
        return
      end
    end
    if params["i-can"]
      if !params["i-can"].empty?
        i_can = Unicode::downcase(params["i-can"])
        service_ids = []

        Service.all.each do |service|
          if Unicode::downcase(service.name).index(i_can)
            service_ids.push(service.id)
          end
        end
        if !service_ids.empty?
          @advertisements = Advertisement.
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
    @advertisement = Advertisement.new
  end

  def create
    @advertisement = Advertisement.new(advertisement_params)
    @queue = Queue.new()
    respond_to do |format|
      if (@advertisement.save && @queue.save)
        current_client.advertisements << @advertisement
        @queue.advertisement << @advertisement
        flash[:success] = "Объявление добавлено";
        format.html { redirect_to current_client }
        #format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        #format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.html { redirect_to current_client, notice: 'Объявление успешно обновлено' }
        #format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        #format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  def perform_ad
    if p = Advertisement.find_by_id(params['id'])
      if (p.state == 0) && (current_client)
        p.update_attribute("worker_id", current_client.id)
        p.update_attribute("state", 1)
        render text: "Объявление забронировано. Ожидайте звонок от заказчика"
        #redirect_back_or ''
      else
        render text: "Объявление не доступно для бронирования"
        #redirect_back_or ''
      end
      #flash[:success] = "Заказ забронирован. Ожидайте звонок от заказчика.#{params[:id]}" 
      #redirect_to ''
    else
      render text: "Такого объявления не существует"
    end
  end

  def worker_cancel
    if ad = Advertisement.find_by_id(params['ad'])
      if (ad.state == 1) && (ad.client_id == current_client.id)
        ad.update_attribute("worker_id", nil)
        ad.update_attribute("state", 0)
        render text: "Исполнитель отменен"
      else
        render text: "Нельзя отменить"
      end
    else
      render text: "Такого объявления не существует"
    end
  end

private
  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

  def advertisement_params
    params.require(:advertisement).permit(
      :description, 
      :price, 
      :city, 
      :address, 
      :date, 
      :start_hour, 
      :end_hour,
      :service_id)
  end


  def correct_advertisement
    if current_client
      redirect_to('') unless current_client.advertisements.find_by_id(params[:id])
    else
      redirect_to('')
    end
  end
end