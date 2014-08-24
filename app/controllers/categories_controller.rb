# encoding: utf-8
class CategoriesController < ApplicationController

	def edit	
	end
	def create
		@category = Category.new(category_params)
		respond_to do |format|
			if @category.save
				format.html { redirect_to new_service_url, notice: 'Категория успешно созданна' }
			else
				format.html { render :new }
			end
		end
	end

	private
		def category_params
    		params.require(:category).permit(:name)
  		end


end