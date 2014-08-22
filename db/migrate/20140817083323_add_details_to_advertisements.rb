class AddDetailsToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :date, :date
    add_column :advertisements, :start_hour, :time
    add_column :advertisements, :end_hour, :time
    add_column :advertisements, :description, :text
  end
end
