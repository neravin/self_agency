class AddStateToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :state, :integer
  end
end
