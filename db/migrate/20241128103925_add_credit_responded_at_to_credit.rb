class AddCreditRespondedAtToCredit < ActiveRecord::Migration[8.0]
  def change
    add_column :credits, :credit_responded_at, :datetime
  end
end
