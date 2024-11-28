class AddDebitRespondedAtToDebit < ActiveRecord::Migration[8.0]
  def change
    add_column :debits, :debit_responded_at, :datetime
  end
end
