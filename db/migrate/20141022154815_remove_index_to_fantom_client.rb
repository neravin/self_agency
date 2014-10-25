class RemoveIndexToFantomClient < ActiveRecord::Migration
  def change
  	remove_index(:clients_fantoms, :name => 'index_clients_fantoms_on_client_id')
  	remove_index(:clients_fantoms, :name => 'index_clients_fantoms_on_fantom_id')
  end
end
