class CreateServerDeletions < ActiveRecord::Migration[8.0]
  def change
    create_table :server_deletions do |t|
      t.references :server
      t.datetime :delete_at, null: false
      t.timestamps
    end
  end
end
