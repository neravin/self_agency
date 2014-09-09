class CreateJoinTableAdvertisementClient < ActiveRecord::Migration
  def change
    create_join_table :advertisements, :clients do |t|
      # t.index [:advertisement_id, :client_id]
      # t.index [:client_id, :advertisement_id]
      t.index :advertisement_id
      t.index :client_id
    end
  end
end
