class Service < ActiveRecord::Base
  has_many :advertisements
  has_many :workers

	validates :name, presence: true
end