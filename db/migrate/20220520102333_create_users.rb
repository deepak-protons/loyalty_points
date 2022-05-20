class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.float :spends
      t.integer :loyalty_points
      t.integer :role
      t.string :time_zone

      t.timestamps
    end
  end
end
