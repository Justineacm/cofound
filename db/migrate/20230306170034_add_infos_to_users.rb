class AddInfosToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :description, :text
    add_column :users, :age, :integer
    add_column :users, :mbti, :string
    add_column :users, :city, :string
    add_column :users, :has_a_project, :boolean
  end
end
