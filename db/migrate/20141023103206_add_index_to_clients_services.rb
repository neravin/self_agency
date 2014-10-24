class AddIndexToClientsServices < ActiveRecord::Migration
  def change
  	add_index(:clients_services, [:client_id, :service_id], unique: true)
  end
end
