#为机构客户管理功能进行数据初始化设置
namespace :organization_migration_task do 
  task :main_task => [:init_notify, :create_functions, :end_notify] do
  end

  desc "init_notify"
  task :init_notify do
    puts "<<<<<<<<<<<<<开始初始化机构客户数据>>>>>>>>>>>>>>"
  end

  desc "create_functions"
  task :create_functions => :environment do
    fns=[ {name: "机构列表",controller: "Organization",action: "index"},

          {name: "机构资料复核",controller: "Organization",action: "list_check"},
          {name: "机构员工资料复核",controller: "OrganizationCustomer",action: "list_check"},
          {name: "机构员工资料修改(离职)",controller: "OrganizationCustomer",action: "list_edit"},

          {name: "机构员工登记申报入保",controller: "OrganizationShebao",action: "list_apply_start"},
          {name: "机构员工登记申报停保",controller: "OrganizationShebao",action: "list_apply_stop"},
          {name: "机构员工登记重新申报入保",controller: "OrganizationShebao",action: "list_apply_restart"},

          {name: "机构员工登记开通公积金",controller: "OrganizationGongjijin",action: "list_apply_start"},
          {name: "机构员工登记停交公积金",controller: "OrganizationGongjijin",action: "list_apply_stop"},
          {name: "机构员工登记重新开通公积金",controller: "OrganizationGongjijin",action: "list_apply_restart"},

          {name: "机构常规提成单录入",controller: "OrganizationChargeTotal",action: "commission_input_allowed"},
          {name: "机构常规提成单审批",controller: "OrganzationCommission",action: "need_approve"},
          {name: "机构其他提成单录入",controller: "OrganizationChargeOther",action: "commission_input_allowed"},
          {name: "机构其他提成单审批",controller: "OrganizationCommissionOther",action: "need_approve"},
          {name: "机构常规资金核对",controller: "OrganizationChargeTotal",action: "list_money_arrival_check"},
          {name: "机构常规提成单复核",controller: "OrganzationCommission",action: "need_finance_check"},
          {name: "机构其他资金核对",controller: "OrganizationChargeOther",action: "list_money_arrival_check"},
          {name: "机构其他提成单复核",controller: "OrganizationCommissionOther",action: "need_finance_check"},

          {name: "机构查询",controller: "Organization",action: "list_total"},
          {name: "机构员工查询",controller: "OrganizationCustomer",action: "list_edit"},


          {name: "机构常规缴费单终审",controller: "OrganizationChargeTotal",action: "list_leader_check"},
          {name: "机构常规缴费单查询",controller: "OrganizationChargeTotal",action: "list_total"},
          {name: "机构常规提成单查询",controller: "OrganzationCommission",action: "list_total"},

          {name: "机构其他缴费单终审",controller: "OrganizationChargeOther",action: "list_leader_check"},
          {name: "机构其他缴费单查询",controller: "OrganizationChargeOther",action: "list_total"},
          {name: "机构其他提成单查询",controller: "OrganizationCommissionOther",action: "list_total"},

          {name: "机构归属管理",controller: "Organization",action: "list_set_user"},
          
          ]
    fns.each do |r|
      puts "  创建功能: " + r.fetch(:name)
      Function.create(r) unless Function.where(r).count>0
    end
  end

  desc "end_notify"
  task :end_notify do
    puts "<<<<<<<<<<<<<完成初始化机构客户数据>>>>>>>>>>>>>>"
  end

end
