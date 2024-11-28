class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.string :stock_identifier
      t.float :stock_last_price

      t.timestamps
    end
  end
end
