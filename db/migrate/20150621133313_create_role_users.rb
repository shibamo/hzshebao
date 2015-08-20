class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :role_users do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
