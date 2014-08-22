class AddServiceRefToAdvertisements < ActiveRecord::Migration
  def change
    add_reference :advertisements, :service, index: true
  end
end
