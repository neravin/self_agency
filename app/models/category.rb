# encoding: utf-8
require 'file_size_validator'
class Category < ActiveRecord::Base
  has_many :services
  mount_uploader :photo, PhotoUploader
  validates :name, presence: true
  validates :photo,
    :file_size => {
      :maximum => 0.5.megabytes.to_i
    }
  validates_processing_of  :photo
end