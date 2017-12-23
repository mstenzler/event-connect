class AddBirthdateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :birthdate, :date
    add_column :users, :age, :integer
    add_column :users, :age_range, :string
  end
end
