class AddClientRefToAdvertisements < ActiveRecord::Migration
  def change
    add_reference :advertisements, :client, index: true
  end
end
