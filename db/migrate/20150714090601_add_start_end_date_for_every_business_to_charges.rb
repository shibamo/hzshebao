class AddStartEndDateForEveryBusinessToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :start_date_shebao, :date
    add_column :charges, :end_date_shebao, :date
    add_column :charges, :start_date_gongjijin, :date
    add_column :charges, :end_date_gongjijin, :date
    add_column :charges, :start_date_fuwufei, :date
    add_column :charges, :end_date_fuwufei, :date
    add_column :charges, :start_date_cailiaofei, :date
    add_column :charges, :end_date_cailiaofei, :date
    add_column :charges, :start_date_bujiao, :date
    add_column :charges, :end_date_bujiao, :date
  end
end
