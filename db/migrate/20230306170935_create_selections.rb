class CreateSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :selections do |t|
      t.references :sender, null: false
      t.references :receiver, null: false
      t.integer :status, default: 0

      t.timestamps
    end
    add_foreign_key "selections", "users", column: "sender_id"
    add_foreign_key "selections", "users", column: "receiver_id"
  end
end
