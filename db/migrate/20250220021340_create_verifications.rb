class CreateVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :verifications do |t|
      t.integer :path
      t.integer :email_id
      t.integer :user_id

      t.timestamps
    end
  end
end
