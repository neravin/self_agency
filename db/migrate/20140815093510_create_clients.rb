class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :photo
      t.string :password_digest
      t.string :remember_token
      t.string :password_reset_token
      t.integer :state
      t.string :confirmation_token
      t.integer :credits
    end
  end
end
