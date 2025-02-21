
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :stripe_id, limit: 50, null: false
      t.boolean :verified, default: false, null: false

      t.timestamps
    end
  end
end
