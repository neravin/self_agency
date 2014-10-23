# encoding: utf-8
class Service < ActiveRecord::Base
  has_many :advertisements
  has_many :workers
  belongs_to :category
  has_and_belongs_to_many :clients

	validates :name, presence: true
end