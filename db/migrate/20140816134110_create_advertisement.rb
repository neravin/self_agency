class CreateAdvertisement < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :name
      t.integer :price
      t.string :city
      t.string :address
    end
  end
end
