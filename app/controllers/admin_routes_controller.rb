# encoding: utf-8
class AdminRoutesController < ApplicationController
 # before_action :set_clien, only: [:show]
  def index
    #@service = Service.all
    #@category = Category.all
   # @client = Client.all
   #@search = Category.search(params[:q])
    #@category = @search.result
  end

  def edit
  	
  end

def set_clien
      @admin_route = AdminRoute.find(params[:id])
    end
  
end