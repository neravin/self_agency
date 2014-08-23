# encoding: utf-8
class Admin < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	has_secure_password
end