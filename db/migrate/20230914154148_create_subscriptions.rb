class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :title
      t.float :price
      t.string :status
      t.string :frequency
      t.integer :tea_units
      t.integer :tea_unit_size
      t.references :tea, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
