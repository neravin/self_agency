class Advertisement < ActiveRecord::Base

  validates :name, :city, :address, :date, :start_hour, :end_hour, :description, presence: true 
  
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