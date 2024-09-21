class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :link_name, null: false
      t.string :web_url, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
