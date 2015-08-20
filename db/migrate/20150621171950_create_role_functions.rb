class CreateRoleFunctions < ActiveRecord::Migration
  def change
    create_table :role_functions do |t|
      t.integer :role_id
      t.integer :function_id

      t.timestamps null: false
    end
  end
end
