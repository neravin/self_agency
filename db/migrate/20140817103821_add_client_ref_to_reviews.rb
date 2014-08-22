class AddClientRefToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :client, index: true
  end
end
