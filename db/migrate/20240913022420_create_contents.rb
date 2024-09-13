class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.integer :genre_id, null: false
      t.string :content_name, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
