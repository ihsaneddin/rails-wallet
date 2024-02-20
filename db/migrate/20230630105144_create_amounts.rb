class CreateAmounts < ActiveRecord::Migration[7.0]
  def change
    create_table :amounts do |t|
      t.string :type
      t.references :account
      t.references :entry
      t.decimal :amount, :precision => 15, :scale => 2
      t.timestamps
    end
  end
end
