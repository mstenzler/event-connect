class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.references :liked_user, references: :users

      t.timestamps
    end
#    add_index :likes, :likes_id
    add_index :likes, [:event_id, :user_id, :liked_user_id], unique: true
  end
end
