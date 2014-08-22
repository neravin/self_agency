class Review < ActiveRecord::Base
	belongs_to :client
	validates :name, presence: true
	validates :description, presence: true
end