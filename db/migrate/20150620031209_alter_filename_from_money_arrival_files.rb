class AlterFilenameFromMoneyArrivalFiles < ActiveRecord::Migration
  def change
    remove_column :money_arrival_files, :filename, :string
    add_column :money_arrival_files, :file_name, :string
  end
end
