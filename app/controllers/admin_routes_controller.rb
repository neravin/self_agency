# encoding: utf-8
class AdminRoutesController < ApplicationController
  
  def index
  	@service = Service.new
    @service = Service.all
  end
end