class AddTypeToClients < ActiveRecord::Migration
  def change
    add_column :clients, :type, :integer
  end
end
