class CreateRsvps < ActiveRecord::Migration[5.0]
  def change
    create_table :rsvps do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.string :code

      t.timestamps
    end
  end
end
