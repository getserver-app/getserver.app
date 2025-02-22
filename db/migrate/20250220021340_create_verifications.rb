class CreateVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :verifications do |t|
      t.string :path, null: false
      t.references :email
      t.references :user

      t.timestamps
    end
  end
end
