class CreateServers < ActiveRecord::Migration[8.0]
  def change
    create_table :servers do |t|
      t.references :user
      t.string :internal_id, null: false
      t.string :provider_identifier, null: false
      t.string :provider_plan_identifier, null: false
      t.string :provider_os_identifier, null: false
      t.string :provider_region_identifier, null: false
      t.boolean :active, default: true
      t.string :stripe_subscription_id, null: false
      t.timestamps
    end

    add_index :servers, :internal_id
  end
end
