class AddServiceRefToWorkers < ActiveRecord::Migration
  def change
    add_reference :workers, :service, index: true
  end
end
