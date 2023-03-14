class AddColumnToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :logo, :string
  end
end
