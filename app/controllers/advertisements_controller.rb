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

    if p != Advertisement.find_by_id(id_ad)
      render text: "Такого объявления не существует"
    elsif !((p.state == 0) && (current_client))
      render text: "Объявление не доступно для бронирования"
    elsif current_client.type_user != 1
      render text: "Заказчики не могут бронировать объявления"
    elsif !(p.client.id != current_client.id)
      render text: "Вы не можете бронировать свое объявление"
    elsif !(fantom = Fantom.find_by_advertisement_id(ud_ad))
      render text: "Объявление не доступно для бронирования"
    elsif fantom_ad.clients.exists?(current_client.id)
      render text: "Вы уже подали заявку"
    else
      fantom_ad.clients << current_client
      render text: "Ожидайте звонок от заказчика"
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

  def agree_order
    if !signed_in?
      render text: "Вы не вошли на сайт"
    elsif !(builder = Client.find_by_id(params[:client_id]))
      render text: "Такого строителя не существует"
    elsif !(advertisement = Advertisement.find_by_id(params[:adv_id]))
      render text: "Такого объявления не существует"
    elsif !(current_client.advertisements.exists?(advertisement))
      render text: "Это не ваше объявление"
    elsif advertisement.worker_id
      render text: "Исполнитель уже определен"
    elsif !(Fantom.find_by_advertisement_id(advertisement.id).clients.exists?(builder.id))
      render text: "Строитель не соглашался делать ваш заказ"
    else
      advertisement.book
      advertisement.update_attribute("worker_id", builder.id)
      render text: "Спасибо, исполнитель определен"
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