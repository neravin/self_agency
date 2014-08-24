class AddWorkerIdToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :worker_id, :integer
  end
end
