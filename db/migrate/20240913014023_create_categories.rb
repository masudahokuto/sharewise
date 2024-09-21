class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :category_name, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end