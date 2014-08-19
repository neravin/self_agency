class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :name
      t.integer :price
      t.string :city
      t.string :address
      t.text :description
    end
  end
end
