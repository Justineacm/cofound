class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :industry
      t.text :pitch
      t.string :pitch_deck
      t.string :city
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
