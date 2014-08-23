class Worker < ActiveRecord::Base
  belongs_to :service
	validates :city, :address, :price, :service_id, presence: true

  States = {
    :open => 0,
    :reserved => 1,
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