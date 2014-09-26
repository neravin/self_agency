class AddTimestampsToAdvertisements < ActiveRecord::Migration
  def change
    add_timestamps(:advertisements)
  end
end
