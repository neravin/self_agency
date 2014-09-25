# encoding: utf-8
class FantomsController < ApplicationController


private 

	def set_fantom
		@fantom = Fantom.find(params[:id])
	end
	def fantom_params
		params.require(:fantom).permit(:id, :advertisement_id)
	end
end