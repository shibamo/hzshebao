Rails.application.routes.draw do

  

  get 'home/index'

  resources :shebao_bases #社保缴费基数

  scope path: '/renewals', controller: :renewals, as: 'renewals' do
    post "need_renew/:id" => :need_renew, :as => "need_renew" #确认客户待续费 
    get "list_waiting" => :list_waiting #已通知续费人员列表 
    post "finish_renew/:id" => :finish_renew, :as => "finish_renew" #续费完成 
    post "stop/:id" => :stop, :as => "stop" #停止服务 
    post "finish_restart/:id" => :finish_restart, :as => "finish_restart" #重新开通
    get "list_stopped" => :list_stopped #已停止服务人员列表 
  end
  resources :renewals #续费

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
  resources :gongjijins  #客户的公积金服务状态记录信息

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
  resources :single_customers do #客户信息记录
    resources :customer_id_card_pictures #原为客户身份证照片,******现直接复用做所有的客户附件文件

    resources :contracts do #客户劳动合同
      get :print_form 
    end

    resources :charges do #客户缴费
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
    post "update_user/:id" => :update_user, :as => "update_user"#执行更新提成单的业务员
    #get 'list_total/(:input_date_from)/(:input_date_from)(.:format)' =>  :list_total, :as => "list_total"
    #post 'list_total(.:format)' =>  :list_total, :as => "list_total"
    match 'list_total(.:format)/(:input_date_from)/(:input_date_to)' =>  :list_total, via:[:get, :post], :as => "list_total" #所有提成单列表,与index的区别是不对当前业务员用户的归属判断
  end

  resources :commissions do #提成单
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
    get 'list_total(.:format)/(:money_arrival_date_from)/(:money_arrival_date_to)' => :list_total, :as => "list_total" #所有缴费单列表,与index的区别是1.不作客户对当前业务员用户的归属判断;2.不需要传入客户id条件
  end

  resources :charges do #客户缴费
    match 'set_money_arrival_date', via: [:get,:patch]
    resources :money_arrival_files
    resources :commissions #提成单
  end

  get 'user/reset_password/:id' => 'users#reset_password', :as => "user_reset_password"
  get 'user/login/(:id)' => "users#login", :as => "user_login"
  get 'user/logout' => "users#logout", :as => "user_logout"
  post 'user/auth' => "users#auth", :as => "user_auth"
  resources :users #用户

  resources :functions #系统功能列表

  resources :roles do
    get :set_users  #角色-用户关联表
    post :update_users
    get :set_functions  #角色-功能关联表
    post :update_functions
  end

  resources :departments #部门

  resources :companies #公司

  resources :administrators #管理员

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
