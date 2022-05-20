class CreateAudits < ActiveRecord::Migration[5.2]
  def change
    create_table :audits do |t|
      t.references :auditable, polymorphic: true
      t.json :data

      t.timestamps
    end
  end
end
