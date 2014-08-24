# encoding: utf-8
class Service < ActiveRecord::Base
  has_many :advertisements
  has_many :workers
  has_many :categories

	validates :name, presence: true
end