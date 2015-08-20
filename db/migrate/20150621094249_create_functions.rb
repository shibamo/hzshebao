class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.string :description

      t.timestamps null: false
    end
  end
end
