class RemoveIndexToClientsIndexClientsServicesOnClientId < ActiveRecord::Migration
  def change
  	remove_index(:clients_services, :name => 'index_clients_services_on_client_id')
  	remove_index(:clients_services, :name => 'index_clients_services_on_service_id')
  end
end
