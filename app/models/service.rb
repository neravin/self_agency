class Service < ActiveRecord::Base
	validates :name, presence: true
	has_many :advertisements
	has_many :workers

end