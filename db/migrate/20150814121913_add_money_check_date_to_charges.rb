class AddMoneyCheckDateToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :money_check_date, :date
  end
end
