class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.string :description
      t.string :currency
      t.date :date
      t.string :type
      t.timestamps
    end
  end
end
