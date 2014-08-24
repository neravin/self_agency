# encoding: utf-8
class AdminRoutesController < ApplicationController
  
  def index
    @service = Service.all
  end
end