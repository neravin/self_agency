# encoding: utf-8
class Advertisement < ActiveRecord::Base
  belongs_to :service
  has_and_belongs_to_many :clients

  validate :start_hour, :happened_at_is_valid_datetime
  validates :description, presence: true
  validates :city, presence: true
  validates :address, presence: true
  validates :date, presence: true
  validates :service_id, presence: true

  def happened_at_is_valid_datetime
    errors.add('Время начала', ' не должно превышать время конца') if (start_hour > end_hour)
  end

  States = {
    :open => 0,
    :reserved => 1,
    :made => 2,
    :canceled => 3
  }
  state_machine :state, :initial => :open, :action => :byad_validation do |variable|
    States.each do |name, value|
      state name, :value => value
    end

    event :book do
      transition all => :reserved
    end

    event :cancelation do
      transition all => :open
    end

    event :made_ad do
      transition all => :made
    end

    event :cancel_ad do
      transition all => :canceled
    end
  end

private
  def byad_validation
    if self.changed == ["state"]
      save!(:validate => false)
    else
      save!(:validate => true)
    end
  end

end