# encoding: utf-8
class AdminRoutesController < ApplicationController
  
  def index
    @service = Service.all
    @category = Category.all
  end
end