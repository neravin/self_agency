class CreateJoinTableQueueClient < ActiveRecord::Migration
  def change
    create_join_table :queues, :clients do |t|
      # t.index [:queue_id, :client_id]
      # t.index [:client_id, :queue_id]
      t.index :queue_id
      t.index :client_id
    end
  end
end
