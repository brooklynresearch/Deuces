class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
      t.boolean :occupied, default: false
      t.integer :row
      t.integer :column
      t.timestamps null: false
    end
  end
end
