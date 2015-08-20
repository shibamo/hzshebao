class AddBusinessActionToMoneyArrivalFiles < ActiveRecord::Migration
  def change
    add_column :money_arrival_files, :business_action, :string
  end
end
