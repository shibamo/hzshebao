Rails.application.routes.draw do
  scope path: '/organization_commission_others', controller: :organization_commission_others, as: 'organization_commission_others' do
    get 'need_approve' => :need_approve #审批
    get 'need_finance_check' => :need_finance_check #财务复核
    match "set_user/:id" => :set_user, via: [:get,:patch], :as => "set_user" #更新提成单业务员设置
    #所有提成单列表,与index的区别是不对当前业务员用户的归属判断
    match 'list_total(.:format)/(:input_date_from)/(:input_date_to)' =>  :list_total, via:[:get, :post], :as => "list_total" 
  end  
  resources :organization_commission_others,except:[:destroy] do#机构其他缴费提成单
    post :approve
    post :finance_check
  end

  scope path: '/organization_charge_others', controller: :organization_charge_others, as: 'organization_charge_others' do
    get "list_by_organization/:organization_id" => :list_by_organization, as: 'list_by_organization' #显示指定机构的缴费记录列表
    get "new/(:organization_id)" => :new, as: 'new' #新建指定机构的缴费记录
    get "list_money_arrival_check" #需要进行资金到账审核的列表
    match "set_money_arrival_date/:id" => :set_money_arrival_date, via: [:get,:patch], as: 'set_money_arrival_date'#设置资金到账日期
    get "finish_money_check/:id" => :finish_money_check, as: 'finish_money_check' #完成资金到账审核
    get 'commission_input_allowed' => :commission_input_allowed #缴费后允许输入提成单
    get 'list_leader_check' => :list_leader_check #需要领导审核的缴费单列表
    post 'leader_check/:id' => :leader_check, :as => "leader_check" #领导完成审核缴费单
    match "query" => :query , via: [:get, :post] #缴费查询
    get 'list_total(.:format)/(a:money_arrival_date_from)/(b:money_arrival_date_to)/(c:money_check_date_from)/(d:money_check_date_to)' => :list_total, 
        :as => "list_total" #所有缴费单列表
  end
  resources :organization_charge_others, except: [:index,:destroy] do #机构其他缴费记录
    resources :organization_commission_others, except: [:index, :edit, :update, :destroy]#机构提成单
  end

  scope path: '/organization_gongjijins', controller: :organization_gongjijins, as: 'organization_gongjijins' do
    get "list_apply_start" => :list_apply_start #需要开通公积金服务的机构员工列表
    post "finish_apply_start/:id" => :finish_apply_start, :as => "finish_apply_start" #完成开通公积金服务
    match "list_apply_stop" => :list_apply_stop, via:[:get, :post] #可能停止公积金服务的机构员工列表
    post "finish_apply_stop/:id" => :finish_apply_stop, :as => "finish_apply_stop" #完成停止公积金服务
    match "list_apply_restart" => :list_apply_restart, via:[:get, :post] #可能重新开通公积金服务的机构员工列表
    post "finish_apply_restart/:id" => :finish_apply_restart, :as => "finish_apply_restart" #完成重新开通公积金服务 
  end
  resources :organization_gongjijins, except: [:index, :show, :new, :create, :edit, :update, :destroy]#机构员工公积金服务状态记录信息

  scope path: '/organization_shebaos', controller: :organization_shebaos, as: 'organization_shebaos' do
    get "list_apply_start" => :list_apply_start #需要开通社保服务的机构员工列表
    post "finish_apply_start/:id" => :finish_apply_start, :as => "finish_apply_start" #完成开通社保服务
    match "list_apply_stop" => :list_apply_stop, via:[:get, :post] #可能停止社保服务的机构员工列表
    post "finish_apply_stop/:id" => :finish_apply_stop, :as => "finish_apply_stop" #完成停止社保服务
    match "list_apply_restart" => :list_apply_restart, via:[:get, :post] #可能重新开通社保服务的机构员工列表
    post "finish_apply_restart/:id" => :finish_apply_restart, :as => "finish_apply_restart" #完成重新开通社保服务 
  end
  resources :organization_shebaos, except: [:index, :show, :new, :create, :edit, :update, :destroy] #机构员工社保服务状态记录信息

  scope path: '/organzation_commissions', controller: :organzation_commissions, as: 'organzation_commissions' do
    get 'need_approve' => :need_approve #审批
    get 'need_finance_check' => :need_finance_check #财务复核
    match "set_user/:id" => :set_user, via: [:get,:patch], :as => "set_user" #更新提成单业务员设置
    #所有提成单列表,与index的区别是不对当前业务员用户的归属判断
    match 'list_total(.:format)/(:input_date_from)/(:input_date_to)' =>  :list_total, via:[:get, :post], :as => "list_total" 
  end  
  resources :organzation_commissions, except:[:new,:create,:destroy] do #机构常规缴费提成单
    post :approve
    post :finance_check
  end

  scope path: '/organization_charges', controller: :organization_charges, as: 'organization_charges' do
    get "list_by_customer/:organization_customer_id" => :list_by_customer, as: "list_by_customer" #按机构员工查询缴费列表
  end
  resources :organization_charges,except:[:index,:new,:create,:edit,:update,:show,:destroy] do
    #机构日常缴费按员工记录,是机构日常缴费总表organization_charge_totals的子记录
  end

  scope path: '/organization_charge_totals', controller: :organization_charge_totals, as: 'organization_charge_totals' do
    get "list_by_organization/:organization_id" => :list_by_organization, as: 'list_by_organization' #显示指定机构的缴费记录列表
    get "new/(:organization_id)" => :new, as: 'new' #新建指定机构的缴费记录
    get "list_money_arrival_check" #需要进行资金到账审核的列表
    match "set_money_arrival_date/:id" => :set_money_arrival_date, via: [:get,:patch], as: 'set_money_arrival_date'#设置资金到账日期
    get "finish_money_check/:id" => :finish_money_check, as: 'finish_money_check' #完成资金到账审核
    get 'commission_input_allowed' => :commission_input_allowed #缴费后允许输入提成单
    get 'list_leader_check' => :list_leader_check #需要领导审核的缴费单列表
    post 'leader_check/:id' => :leader_check, :as => "leader_check" #领导完成审核缴费单
    match "query" => :query , via: [:get, :post] #缴费查询
    get 'list_total(.:format)/(a:money_arrival_date_from)/(b:money_arrival_date_to)/(c:money_check_date_from)/(d:money_check_date_to)' => :list_total, 
        :as => "list_total" #所有缴费单列表
  end
  resources :organization_charge_totals , except: [:index, :new, :destroy] do
  #机构日常缴费总表(由业务员自行输入所缴服务费的服务时间段与总值,系统生成时预先根据选定的人和月份数算好初始值,但允许业务员修改)
    resources :organzation_commissions, except: [:index, :edit, :update, :destroy]#机构提成单
  end

  scope path: '/organization_charge_templates', controller: :organization_charge_templates, as: 'organization_charge_templates' do
    get "list_by_organization/:organization_id" => :list_by_organization, as: 'list_by_organization'
  end
  resources :organization_charge_templates, except: [:new] #机构所属员工日常缴费模板

  scope path: '/organization_customers', controller: :organization_customers, as: 'organization_customers' do
    match "list_managed" => :list_managed, via: [:get, :post] #本人管理的机构员工客户查询列表
    match "list_total" => :list_total, via: [:get, :post] #所有机构员工客户查询列表
    #指定机构所属的员工客户查询列表
    match "list_by_organization/:organization_id" => :list_by_organization, via: [:get, :post], as: 'list_by_organization'
    get "new/(:organization_id)" => :new, as: 'new'
    get "list_check" => :list_check #需要复核的机构员工客户列表
    post "finish_check/:id" => :finish_check, as: "finish_check" #完成机构员工客户资料复核
    match "list_edit" => :list_edit, via: [:get, :post] #可能修改客户资料的客户列表
    #match "query" => :query , via: [:get, :post] #机构员工客户查询,目前直接使用list_edit的简单查询功能代替
  end
  resources :organization_customers, except: [:new, :index] do #机构员工客户
    resources :organization_charge_templates, except:[:destroy] #机构所属员工日常缴费模板
  end

  #原为客户身份证照片,现复用做所有的客户附件文件
  scope path: '/customer_id_card_pictures', controller: :customer_id_card_pictures, as: 'customer_id_card_pictures' do
    get "new_organization_customer_item/:organization_customer_id" => :new_organization_customer_item, 
                                                                  as: 'new_organization_customer_item'
    post "create_organization_customer_item" => :create_organization_customer_item, as: 'create_organization_customer_item'
  end

  scope path: '/organizations', controller: :organizations, as: 'organizations' do
    match "query" => :query , via: [:get, :post] #机构查询
    get "list_check" => :list_check #需要复核的机构列表   
    post "finish_check/:id" => :finish_check, as: "finish_check" #完成机构复核
    match "list_total" => :list_total, via: [:get, :post] #机构列表
    match "list_edit" => :list_edit, via: [:get, :post] #修改机构资料的列表
    get "list_set_user"  #机构列表,用于更新机构所属业务员设置
    match "set_user/:id" => :set_user, via: [:get,:patch], :as => "set_user" #更新机构所属业务员设置
  end
  resources :organizations, except:[:destroy] #机构

  get 'home/index'

  resources :shebao_bases, except:[:destroy] #社保缴费基数

  scope path: '/renewals', controller: :renewals, as: 'renewals' do
    post "need_renew/:id" => :need_renew, :as => "need_renew" #确认客户待续费 
    get "list_waiting" => :list_waiting #已通知续费人员列表 
    post "finish_renew/:id" => :finish_renew, :as => "finish_renew" #续费完成 
    post "stop/:id" => :stop, :as => "stop" #停止服务 
    post "finish_restart/:id" => :finish_restart, :as => "finish_restart" #重新开通
    get "list_stopped" => :list_stopped #已停止服务人员列表 
  end
  resources :renewals, except:[:destroy] #续费

  root 'home#index' #首页

  scope path: '/gongjijins', controller: :gongjijins, as: 'gongjijins' do
    get "list_apply_start" => :list_apply_start #需要开通公积金服务的客户列表
    post "finish_apply_start/:id" => :finish_apply_start, :as => "finish_apply_start" #完成开通公积金服务
    match "list_apply_stop" => :list_apply_stop, via:[:get, :post] #可能停止公积金服务的客户列表
    post "finish_apply_stop/:id" => :finish_apply_stop, :as => "finish_apply_stop" #完成停止公积金服务
    match "list_apply_restart" => :list_apply_restart, via:[:get, :post] #可能重新开通公积金服务的客户列表
    post "finish_apply_restart/:id" => :finish_apply_restart, :as => "finish_apply_restart" #完成重新开通公积金服务 
    get "list_need_renew(.:format)" => :list_need_renew, :as => "list_need_renew" #公积金待续费的客户列表
  end
  resources :gongjijins, except:[:destroy]  #客户的公积金服务状态记录信息

  scope path: '/single_customers', controller: :single_customers, as: 'single_customers' do
    match "query" => :query , via: [:get, :post] #客户查询
    match "list_set_user" => :list_set_user, via: [:get, :post] #客户归属业务员管理列表
    get "set_user/:id" => :set_user , :as => "set_user" #指定客户归属业务员管理
    post "update_user/:id" => :update_user, :as => "update_user"#执行更新客户归属业务员
    get "list_check" => :list_check #需要复核的客户列表    
    post "finish_check/:id" => :finish_check, :as => "finish_check" #完成客户复核
    get "list_apply_start" => :list_apply_start #需要申报入保的客户列表
    get "export_list_apply_start" => :export_list_apply_start #导出需要申报入保的客户列表文件
    post "finish_apply_start/:id" => :finish_apply_start, :as => "finish_apply_start" #完成申报入保
    match "list_apply_stop" => :list_apply_stop, via:[:get, :post] #可能申报停保的客户列表
    post "finish_apply_stop/:id" => :finish_apply_stop, :as => "finish_apply_stop" #完成申报停保 
    match "list_apply_restart" => :list_apply_restart, via: [:get, :post] #可能重新申报入保 的客户列表
    post "finish_apply_restart/:id" => :finish_apply_restart, :as => "finish_apply_restart" #完成重新申报入保 
    get "list_need_renew(.:format)" => :list_need_renew, :as => "list_need_renew" #待续费的客户列表 
    get "list_need_append_shebao" => :list_need_append_shebao #社保待补费的客户列表 
    get "list_total(.:format)" => :list_total, :as => "list_total" #所有客户列表,与index的区别是不作客户对当前业务员用户的归属判断
    match "list_edit" => :list_edit, via: [:get, :post] #可能修改客户资料的客户列表
  end
  resources :single_customers, except:[:destroy] do #客户信息记录
    resources :customer_id_card_pictures, except:[:destroy] #原为客户身份证照片,现直接复用做所有的客户附件文件

    resources :contracts, except:[:destroy] do #客户劳动合同
      get :print_form 
    end

    resources :charges, except:[:destroy] do #客户缴费
      get :print_form 
    end
  end

  #上传的客户信息附件下载
  get 'customer_id_card_pictures/send_raw/:id' => 'customer_id_card_pictures#send_raw', :as => "customer_id_card_picture_send_raw" 

  
  #上传的资金到账凭证附件下载
  get 'money_arrival_files/send_raw/:id' => 'money_arrival_files#send_raw', :as => "money_arrival_files_send_raw" 
  get 'money_arrival_files/send_display/:id' => 'money_arrival_files#send_display', :as => "money_arrival_files_send_display" 
  get 'money_arrival_files/new/:business_type/:extra_data/:main_object_id/:business_action'=> 'money_arrival_files#new', 
                                                                                                :as => "money_arrival_files_new" 
  post 'money_arrival_files/create/:business_type/:extra_data/:main_object_id/:business_action'=> 'money_arrival_files#create', 
                                                                                                :as => "money_arrival_files_create" 
  #资金到账凭证(上传的文件),可能同时为新客户缴费,老客户续费,补交每年调整费业务服务
  #再次调整,可能同时为申报[入;停;重新入]保, [入;停保;重新入]公积金服务
  resources :money_arrival_files, except: [:new, :destroy,:update]


  scope path: '/commissions', controller: :commissions, as: 'commissions' do
    get 'need_approve' => :need_approve #审批
    get 'need_finance_check' => :need_finance_check #财务复核
    get 'need_pay' => :need_pay #支付
    get "set_user/:id" => :set_user , :as => "set_user" #指定提成单业务员设置
    post "update_user/:id" => :update_user, :as => "update_user"#更新提成单的业务员
    #get 'list_total/(:input_date_from)/(:input_date_from)(.:format)' =>  :list_total, :as => "list_total"
    #post 'list_total(.:format)' =>  :list_total, :as => "list_total"

    #所有提成单列表,与index的区别是不对当前业务员用户的归属判断
    match 'list_total(.:format)/(:input_date_from)/(:input_date_to)' =>  :list_total, via:[:get, :post], :as => "list_total" 
  end

  resources :commissions, except:[:destroy] do #提成单
    post :approve
    post :finance_check
    post :pay
  end
  
  scope path: '/charges', controller: :charges, as: 'charges' do
    match "query" => :query , via: [:get, :post] #缴费查询
    match 'for_money_arrival_check' => :money_arrival_check, via: [:get, :post], :as => "for_money_arrival_check" #缴费到账检查清单
    get 'finish_money_check/:id' => :finish_money_check, :as => "finish_money_check" #确认缴费到账
    get 'for_commission_input_allowed' => :commission_input_allowed #缴费后允许输入提成单
    get 'for_leader_check' => :list_for_leader_check #需要领导审核的缴费单列表
    post 'leader_check/:id' => :leader_check, :as => "leader_check" #领导完成审核缴费单
    get 'list_total(.:format)/(a:money_arrival_date_from)/(b:money_arrival_date_to)/(c:money_check_date_from)/(d:money_check_date_to)' => :list_total, 
        :as => "list_total" #所有缴费单列表,与index的区别是1.不作客户对当前业务员用户的归属判断;2.不需要传入客户id条件
  end

  resources :charges, except:[:destroy] do #客户缴费
    match 'set_money_arrival_date', via: [:get,:patch]
    resources :money_arrival_files,except:[:destroy]
    resources :commissions,except:[:destroy] #提成单
  end

  get 'user/reset_password/:id' => 'users#reset_password', :as => "user_reset_password"
  get 'user/login/(:id)' => "users#login", :as => "user_login"
  get 'user/logout' => "users#logout", :as => "user_logout"
  post 'user/auth' => "users#auth", :as => "user_auth"
  resources :users,except:[:destroy] #用户

  resources :functions, except:[:destroy] #系统功能列表

  resources :roles, except:[:destroy] do
    get :set_users  #角色-用户关联表
    post :update_users
    get :set_functions  #角色-功能关联表
    post :update_functions
  end

  resources :departments, except:[:destroy] #部门

  resources :companies, :only => [] #公司

  resources :administrators, :only => [] #管理员

end
