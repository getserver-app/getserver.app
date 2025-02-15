class CreateVps < ActiveRecord::Migration[8.0]
  def change
    create_table :vps do |t|
      t.string :provider_identifier, null: false
      t.integer :price, null: false
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
