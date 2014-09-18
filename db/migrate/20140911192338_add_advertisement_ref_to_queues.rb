class AddAdvertisementRefToQueues < ActiveRecord::Migration
  def change
    add_reference :queues, :advertisement, index: true
  end
end
