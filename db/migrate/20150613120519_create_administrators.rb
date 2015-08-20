class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :password_digest
      t.datetime :last_login_time

      t.timestamps null: false
    end
  end
end
