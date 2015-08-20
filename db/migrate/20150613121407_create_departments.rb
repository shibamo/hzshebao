class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.boolean :is_valid
      t.integer :display_order
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
