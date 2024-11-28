class AddCreditRespondedByToCredit < ActiveRecord::Migration[8.0]
  def change
    add_column :credits, :credit_responded_by, :integer
  end
end
