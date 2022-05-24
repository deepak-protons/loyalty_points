class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :dob
      t.float :spends
      t.integer :loyalty_points
      t.integer :role, default: 0
      t.string :time_zone

      t.timestamps
    end
  end
end
