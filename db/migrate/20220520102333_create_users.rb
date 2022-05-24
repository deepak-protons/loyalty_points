class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :dob
      t.float :spends, default: 0.0
      t.integer :loyalty_points, default: 0
      t.integer :role, default: 0
      t.string :time_zone

      t.timestamps
    end
  end
end
