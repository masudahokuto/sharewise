class ChangeIsActiveDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :is_active, :boolean, default: true, null: false
  end
end