class AddGeshuiAndChajiaToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :price_geshui, :decimal, {:default=> 0}
    add_column :charges, :months_geshui, :integer, {:default=> 0}
    add_column :charges, :start_date_geshui, :date
    add_column :charges, :end_date_geshui, :date
    add_column :charges, :price_chajia, :decimal, {:default=> 0}
    add_column :charges, :months_chajia, :integer, {:default=> 0}
    add_column :charges, :start_date_chajia, :date
    add_column :charges, :end_date_chajia, :date
  end
end
