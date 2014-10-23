class CreateJoinTableServiceClient < ActiveRecord::Migration
  def change
    create_join_table :services, :clients do |t|
      # t.index [:service_id, :client_id]
      # t.index [:client_id, :service_id]
      t.index :service_id
      t.index :client_id
    end
  end
end
