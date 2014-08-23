# encoding: utf-8
class SessionsAdminController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
  	admin = Admin.find_by(name: params[:name])
  		if admin and admin.authenticate(params[:password])
  			session[:admin_id] = admin.id
  			redirect_to admin_routes_index_path
  		else
  			redirect_to login_url, alert: "Неверная комбинация имени и пароля"
  		end
  end

  def destroy
  	 session[:admin_id] = nil
  	 redirect_to '', notice: "Сеанс работы завершен"
  end
end
