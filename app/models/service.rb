# encoding: utf-8
class Service < ActiveRecord::Base
  has_many :advertisements
  has_many :workers
  belongs_to :category

	validates :name, presence: true
end