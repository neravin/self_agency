# encoding: utf-8
class CategoriesController < ApplicationController
	before_action :set_category, only: [:show, :edit, :update, :destroy]
	
	def new
		@category = Category.new
	end
	
	def edit	
	end
	

	def create
		@category = Category.new(category_params)
		respond_to do |format|
			if @category.save
				format.html { redirect_to admin_routes_index_url, notice: 'Категория успешно созданна' }
			else
				format.html { render :new }
			end
		end
	end

	def update
		respond_to do |format|
  		if @category.update(category_params)
  			format.html { redirect_to admin_routes_index_path }
  		else
  			format.html { render :edit }

  		end
  	end
	end

	def destroy
		@category.destroy
		respond_to do |format|
			format.html { redirect_to admin_routes_index_url }
		end
	end

private
	def set_category
		@category = Category.find(params[:id])
	end

	def category_params
		params.require(:category).permit(:name, :photo)
	end


end