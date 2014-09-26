class AddDurationToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :duration, :integer
  end
end
