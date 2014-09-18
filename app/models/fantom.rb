# encoding: utf-8
class Fantom < ActiveRecord::Base
	belongs_to :advertisement
	has_and_belongs_to_many :client
end