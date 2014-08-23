# encoding: utf-8
class HomeController < ApplicationController
  skip_before_action :authorize
  def index
    @green_background = true
  end
end
