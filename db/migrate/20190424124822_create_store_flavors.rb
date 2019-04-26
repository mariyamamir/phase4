class CreateStoreFlavors < ActiveRecord::Migration[5.2]
  def change
    create_table :store_flavors do |t|
      t.references :store, foreign_key: true
      t.references :flavor, foreign_key: true

      t.timestamps
    end
  end
end
