class AlterDefaultToFieldsInCharges < ActiveRecord::Migration
  def change
  	change_column_default :charges, :price_shebao, 0
  	change_column_default :charges, :months_shebao, 0
  	change_column_default :charges, :price_gongjijin, 0
  	change_column_default :charges, :months_gongjijin, 0
  	change_column_default :charges, :price_fuwufei, 0
  	change_column_default :charges, :months_fuwufei, 0
  	change_column_default :charges, :price_cailiaofei, 0
  	change_column_default :charges, :months_cailiaofei, 0
  	change_column_default :charges, :price_bujiao, 0
  	change_column_default :charges, :months_bujiao, 0
  end
end
