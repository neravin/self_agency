class Worker < ActiveRecord::Base
	validates :name, :city, :address, :price, presence: true
end