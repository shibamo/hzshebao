class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :logon_name
      t.string :password_digest
      t.boolean :is_valid
      t.boolean :is_leader
      t.boolean :is_admin

      t.timestamps null: false
    end
  end
end
