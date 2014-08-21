class AddStateToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :state, :integer
  end
end
