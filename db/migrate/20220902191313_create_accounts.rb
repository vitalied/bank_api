class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :iban, null: false, limit: 34, index: { unique: true }
      t.decimal :amount, null: false, default: 0.0, precision: 10, scale: 2

      t.references :created_by, foreign_key: { to_table: :users }
      t.references :updated_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
