class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
      t.boolean :occupied, default: false
      t.string :row
      t.string :column
      t.timestamps null: false
    end
  end
end
