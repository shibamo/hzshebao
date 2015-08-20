class AddMoneyArrivalDateToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :money_arrival_date, :date
  end
end
