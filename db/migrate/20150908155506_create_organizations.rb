class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :abbr
      t.string :address
      t.string :person_in_charge
      t.string :email
      t.string :tel
      t.string :fax
      t.string :contact_person
      t.string :contact_tel
      t.string :contact_fax
      t.date :start_date
      t.string :workflow_state
      t.integer :user_id
      t.integer :is_valid

      t.timestamps null: false
    end
  end
end
