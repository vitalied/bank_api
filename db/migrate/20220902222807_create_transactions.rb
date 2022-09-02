class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :transaction_type, null: false, limit: 10, index: true
      t.string :sender_iban, null: false, limit: 34, index: true
      t.string :receiver_iban, null: false, limit: 34, index: true
      t.decimal :amount, null: false, default: 0.0, precision: 10, scale: 2
      t.string :notes

      t.references :created_by, foreign_key: { to_table: :users }
      t.references :updated_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
