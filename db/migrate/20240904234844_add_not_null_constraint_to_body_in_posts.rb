class AddNotNullConstraintToBodyInPosts < ActiveRecord::Migration[6.0]
  def change
    change_column_null :posts, :body, false
  end
end