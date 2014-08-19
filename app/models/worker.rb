class Worker < ActiveRecord::Base
	validates :name, :city, :address, :description, presence: true

end