class ChangeOrganizationChargeTemplatesDecimalScale < ActiveRecord::Migration
  def change
    change_column :organization_charge_templates, :price_shebao_base, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_shebao_qiye, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_shebao_geren, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_canbao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_shebao_guanli, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_gongjijin_base, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_gongjijin_qiye, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_gongjijin_geren, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_gongjijin_guanli, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_geshui, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_qita_1, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_qita_2, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_qita_3, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_bujiao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_yujiao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_templates, :price_gongzi, :decimal, precision: 10, scale: 2
  end
end
