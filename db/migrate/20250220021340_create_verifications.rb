class CreateVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :verifications do |t|
      t.integer :path
      t.string :email

      t.timestamps
    end
  end
end
