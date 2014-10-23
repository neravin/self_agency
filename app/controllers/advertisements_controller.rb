# encoding: utf-8
class AdvertisementsController < ApplicationController
  skip_before_action :authorize
	before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
	before_action :correct_advertisement, only: [:edit, :update, :destroy]

  def index
    buf         = Advertisement.all
    category_id = params[:category].to_i
    @service_id = params[:service_id].to_i
    @price      = params[:price].to_i
    if category_id && (category_id != 0)
      category = Category.find_by_id(category_id)
      if category
        if @service_id && (@service_id != 0)
          services_id = category.services.where(:id => @service_id)
        else
          services_id = category.services.map(&:id)
        end
        buf = buf.where(:service_id => services_id)
        @category_id = category_id
      end
    end
    if @price && (@price != 0)
      buf = buf.where("price >= ?", @price)
    end
    if buf
      @advertisements = buf.page(params[:page]).per_page(3)
    end
    
    

  def new
    @advertisement = Advertisement.new
  end

  def create
    @advertisement = Advertisement.new(advertisement_params)
    respond_to do |format|
      if (@advertisement.save)
        @fantom = Fantom.new()
        if (@fantom.save)
          @fantom.update_attribute("advertisement_id", @advertisement.id)
          @advertisement.fantom = @fantom
          @advertisement.save
          current_client.advertisements << @advertisement
          format.json { render json: @advertisement.to_json(:include => { :service => { :only => [:id, :name], :include => { :category => { :only => [:id, :name]  } } } } ), status: :created, location: @advertisement }
        end

      else
        format.json { render :json => { :error => @advertisement.errors.messages }, :status => 500 }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.json { render json: @advertisement.to_json(:include => { :service => { :only => [:id, :name], :include => { :category => { :only => [:id, :name]  } } } } ), status: :created, location: @advertisement }
        #format.html { redirect_to current_client, notice: 'Объявление успешно обновлено' }
        #format.json { render :show, status: :ok, location: @advertisement }
      else
        format.json { render :json => { :error => @advertisement.errors.messages }, :status => 500 }
        #format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    fantom = @advertisement.fantom
    fantom.clients.delete()

    @advertisement.destroy
    render json: { success: true }
    #respond_to do |format|
      #format.html { redirect_to advertisements_path }
    #end
  end

  def perform_ad
    id_ad = params['id'].to_i
    if p = Advertisement.find_by_id(id_ad)
      if (p.state == 0) && (current_client)
        if (p.client.id != current_client.id)
          fantom_ad = Fantom.find_by_advertisement_id(id_ad)
          if fantom_ad
            if fantom_ad.clients.exists?(current_client.id)
              render text: "Вы уже подали заявку"
            else
              fantom_ad.clients << current_client
              render text: "Ожидайте звонок от заказчика"
            end
          else
            render text: "Объявление не доступно для бронирования"
          end
        else
          render text: "Вы не можете бронировать свое объявление"
        end
      else
        render text: "Объявление не доступно для бронирования"
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
      :duration,
      :service_id,
      :client_id)
  end


  def correct_advertisement
    if current_client
      redirect_to('') unless current_client.advertisements.find_by_id(params[:id])
    else
      redirect_to('')
    end
  end
end