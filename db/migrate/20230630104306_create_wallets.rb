class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :owner, polymorphic: true
      t.string :number
      t.timestamps
    end
  end
end
