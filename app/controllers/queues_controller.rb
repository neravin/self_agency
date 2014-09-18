# encoding: utf-8
class QueuesController < ApplicationController


private 

	def set_queue
		@queue = Queue.find(params[:id])
	end
	def queue_params
		params.require(:queue).permit(:id, :advertisement_id)
	end
end