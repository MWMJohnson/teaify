class ChangeTeaReferenceNull < ActiveRecord::Migration[7.0]
  def change
    change_column :subscriptions, :tea_id, :bigint, null: true
  end
end
