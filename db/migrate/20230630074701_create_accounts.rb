class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :wallet
      t.string :currency, null: false, default: "IDR"
      t.integer :lock_version, default: 0
      t.timestamps
    end
  end
end
