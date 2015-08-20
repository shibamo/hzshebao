class CreateShebaoBases < ActiveRecord::Migration
  def change
    create_table :shebao_bases do |t|
      t.decimal :base
      t.integer :year
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
