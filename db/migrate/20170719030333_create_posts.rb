class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :title, null: false
      t.text :content, null: false
      t.boolean :enabled, null: false, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
