class AddIndexToClientsFantoms < ActiveRecord::Migration
  def change
  	add_index(:clients_fantoms, [:client_id, :fantom_id], unique: true)
  end
end
