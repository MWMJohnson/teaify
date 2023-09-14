class ChangeCustomerReferenceNull < ActiveRecord::Migration[7.0]
  def change
    change_column :subscriptions, :customer_id, :bigint, null: true
  end
end
