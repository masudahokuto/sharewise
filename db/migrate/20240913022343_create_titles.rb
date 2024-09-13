class CreateTitles < ActiveRecord::Migration[6.1]
  def change
    create_table :titles do |t|
      t.integer :category_id, null: false
      t.string :title_name, null: false

      t.timestamps
    end
  end
end
