# encoding: utf-8
class AdminRoutesController < ApplicationController
  
  def index
  	@service = Service.new
  	@service_id = Service.all
  end
end