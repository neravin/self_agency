# encoding: utf-8
class CategoriesController < ApplicationController
	before_action :set_category, only: [:show, :edit, :update, :destroy]
	skip_before_action :authorize, only: [:index]

	def index
		@type = params[:type]

		if @type == "1" || @type == "2"
			@search = Category.search(params[:q])
            @category = @search.result
		else
			redirect_to ''
		end
		
		if @type == "1" 
			@tab_current = 2
		elsif @type == "2"
			@tab_current = 3
		end
		@search = Category.search(params[:q])
    	@category = @search.result
	end

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