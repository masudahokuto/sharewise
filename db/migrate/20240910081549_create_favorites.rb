class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, foreigh_key: true, null: false
      t.references :post, foreign_key: true, null: false

      t.timestamps
      t.index [:user_id, :post_id], unique: true
    end
  end
end
