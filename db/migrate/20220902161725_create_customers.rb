class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false, limit: 100, index: { unique: true }

      t.timestamps
    end
  end
end
