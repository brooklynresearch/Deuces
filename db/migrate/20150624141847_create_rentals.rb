class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.boolean :current, default: true
      t.integer :locker_id
      t.string :last_name
      t.string :phone_number
      t.string :hashed_id
      t.datetime :end_time
      t.timestamps null: false
    end
  end
end
