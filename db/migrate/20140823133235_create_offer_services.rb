class CreateOfferServices < ActiveRecord::Migration
  def change
    create_table :offer_services do |t|
      t.string :name
      t.text :description
    end
  end
end
