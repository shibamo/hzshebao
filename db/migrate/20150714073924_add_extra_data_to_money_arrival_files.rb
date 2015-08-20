class AddExtraDataToMoneyArrivalFiles < ActiveRecord::Migration
  def change
    add_column :money_arrival_files, :extra_data, :string
  end
end
