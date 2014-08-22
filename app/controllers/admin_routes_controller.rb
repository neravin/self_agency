class AdminRoutesController < ApplicationController
  
  def index
  	@service = Service.new
  end
end