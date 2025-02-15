
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :stripe_id, limit: 50, null: true

      t.timestamps
    end
  end
end
