class CreateServerDeletions < ActiveRecord::Migration[8.0]
  def change
    create_table :server_deletions do |t|
      t.string :server_id, null: false
      t.datetime :delete_at, null: false
      t.timestamps
    end
  end
end
