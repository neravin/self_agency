class AddAdvertisementRefToFantoms < ActiveRecord::Migration
  def change
    add_reference :fantoms, :advertisement, index: true
  end
end
