class CreateAdmin < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name
      t.string :password_digest
    end
  end
end
