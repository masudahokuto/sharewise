class RemoveDefaultTimestampsFromCategories < ActiveRecord::Migration[6.0]
  def change
    change_column_default :categories, :created_at, from: -> { 'CURRENT_TIMESTAMP' }, to: nil
    change_column_default :categories, :updated_at, from: -> { 'CURRENT_TIMESTAMP' }, to: nil
  end
end
