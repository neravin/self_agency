class AddClientRefToWorkers < ActiveRecord::Migration
  def change
    add_reference :workers, :client, index: true
  end
end
