class CreateJoinTableFantomClient < ActiveRecord::Migration
  def change
    create_join_table :fantoms, :clients do |t|
      # t.index [:fantom_id, :client_id]
      # t.index [:client_id, :fantom_id]
      t.index :fantom_id
      t.index :client_id
    end
  end
end
