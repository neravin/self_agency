class AddTimestampsToWorkers < ActiveRecord::Migration
  def change
    add_timestamps(:workers)
  end
end
