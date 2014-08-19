class ReviewsController < ApplicationController

	def create
		@review = Review.new(review_params)
		@otpravitel = Client.find_by_id(params[:id_otp])
		if @review.save
			@review.update_attribute("author_id",current_client.id)
			@otpravitel.reviews << @review
			redirect_to ''
		else 
			redirect_to current_client
		end

	end

	def review_params
    	params.require(:review).permit(:name, :description, :author_id)
  	end


end