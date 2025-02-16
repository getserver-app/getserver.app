class CreateEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :emails do |t|
      t.string :email, limit: 320, null: false
      t.string :responsibility, limit: 100, null: false
      t.timestamps
    end

    add_index :emails, :email
  end
end
