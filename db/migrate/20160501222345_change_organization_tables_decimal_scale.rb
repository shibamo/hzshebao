class ChangeOrganizationTablesDecimalScale < ActiveRecord::Migration
  def change
    #organization_charge_others
    change_column :organization_charge_others, :price_fuwufei, :decimal, precision: 10, scale: 2
    change_column :organization_charge_others, :price_canbao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_others, :price_chajia, :decimal, precision: 10, scale: 2
    change_column :organization_charge_others, :price_gonghui, :decimal, precision: 10, scale: 2
    change_column :organization_charge_others, :price_qita_1, :decimal, precision: 10, scale: 2
    change_column :organization_charge_others, :price_qita_2, :decimal, precision: 10, scale: 2
    change_column :organization_charge_others, :price_qita_3, :decimal, precision: 10, scale: 2
    #organization_charge_totals
    change_column :organization_charge_totals, :price_shebao_base, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_shebao_qiye, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_shebao_geren, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_canbao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_shebao_guanli, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_gongjijin_base, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_gongjijin_qiye, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_gongjijin_geren, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_gongjijin_guanli, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_geshui, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_qita_1, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_qita_2, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_qita_3, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_bujiao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_yujiao, :decimal, precision: 10, scale: 2
    change_column :organization_charge_totals, :price_gongzi, :decimal, precision: 10, scale: 2
    #organization_charges
    change_column :organization_charges, :price_shebao_base, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_shebao_qiye, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_shebao_geren, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_canbao, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_shebao_guanli, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_gongjijin_base, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_gongjijin_qiye, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_gongjijin_geren, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_gongjijin_guanli, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_geshui, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_qita_1, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_qita_2, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_qita_3, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_bujiao, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_yujiao, :decimal, precision: 10, scale: 2
    change_column :organization_charges, :price_gongzi, :decimal, precision: 10, scale: 2
    #organization_commission_others
    change_column :organization_commission_others, :bonus_reference, :decimal, precision: 10, scale: 2
    change_column :organization_commission_others, :bonus, :decimal, precision: 10, scale: 2
    #organzation_commissions
    change_column :organzation_commissions, :bonus_reference, :decimal, precision: 10, scale: 2
    change_column :organzation_commissions, :bonus, :decimal, precision: 10, scale: 2
  end
end
