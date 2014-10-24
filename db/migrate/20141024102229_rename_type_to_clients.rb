class RenameTypeToClients < ActiveRecord::Migration
  def change
  	rename_column :clients, :type, :type_user
  end
end
