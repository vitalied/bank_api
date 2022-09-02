class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :access_token, null: false, limit: 40, index: { unique: true }
      t.string :username, null: false, limit: 100, index: { unique: true }

      t.timestamps
    end
  end
end
