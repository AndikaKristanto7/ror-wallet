class AddDebitRespondedByToDebit < ActiveRecord::Migration[8.0]
  def change
    add_column :debits, :debit_responded_by, :integer
  end
end
