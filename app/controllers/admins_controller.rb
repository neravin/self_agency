# encoding: utf-8
class AdminsController < ApplicationController
	before_action :set_admin, only: [:update]
	def index
		@admins = Admin.order(:name)
	end

	def new 
		@admin = Admin.new
	end 
	def create
		@admin = Admin.new(admin_params)	
		respond_to do |format|
			if @admin.save
				format.html { redirect_to admins_url,
					notice: "Пользователь #{@admin.name} был успешно создан."}
				format.json { render action: 'show', status: :created, location: @admin }
			else
				format.html { render action: 'new'}
				format.json { render json: @admin.errors, status: :unprocessable_entity}
			end
		end
	end

	def update
		respond_to do |format|
			if @admin.save
				format.html { redirect_to admins_url,
					notice: "Пользователь #{@admin.name} был успешно создан."}
				format.json { render action: 'show', status: :created, location: @admin }
			else
				format.html { render action: 'new'}
				format.json { render json: @admin.errors, status: :unprocessable_entity}
			end
		end
	end

private
	def set_admin
      @admin = Admin.find(params[:id])
    end
	def admin_params
    	params.require(:admin).permit(:name, :password, :password_confirmation)
  	end
end
