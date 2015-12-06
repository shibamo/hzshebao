module OrganizationChargeHelper
#为机构员工的社保和公积金服务提供工作流相关的公共功能集
  extend ActiveSupport::Concern
  include PagerHelper

  included do
    scope :of_organization, ->(organization_ids) {where(organization_id: organization_ids).order(:start_date)}

    scope :managed_by_users, ->(user_ids) { joins(:organization).where("organizations.user_id = :user_ids", user_ids: user_ids) }

    scope :of_customer_name_like, ->(partial_name) { joins(:organization).where("organizations.name like :partial_name",
                                                                            partial_name: '%' + partial_name + '%')}
    scope :of_money_arrival_date_from, ->(money_arrival_date_from) { where(":money_arrival_date_from <= money_arrival_date",
                                                                      money_arrival_date_from:  money_arrival_date_from)}
    scope :of_money_arrival_date_to, ->(money_arrival_date_to) { where("money_arrival_date <= :money_arrival_date_to", 
                                                                      money_arrival_date_to:  money_arrival_date_to)}
    scope :of_money_check_date_from, ->(money_check_date_from) { where(":money_check_date_from <= money_check_date",
                                                                      money_check_date_from:  money_check_date_from)}
    scope :of_money_check_date_to, ->(money_check_date_to) { where("money_check_date <= :money_check_date_to", 
                                                                      money_check_date_to:  money_check_date_to)}  

    #使用状态机管理缴费单状态
    workflow do
      state :new do #新建
        event :finish_money_check, :transitions_to => :money_arrived
      end

      state :money_arrived do #资金已到账
        event :finish_commission_form, :transitions_to => :commission_finished
      end

      state :commission_finished do #提成单已填写
        event :finish_leader_check, :transitions_to => :leader_check_finished
      end

      state :leader_check_finished do #领导已审核
      end
    end
    #状态名与中文名对应表
    WORKFLOW_STATE_NAMES = {new: :新建, money_arrived: :资金已到账, commission_finished: :提成单已填写, leader_check_finished: :领导已审核}
    #事件(操作)名与中文名对应表
    WORKFLOW_EVENT_NAMES = {finish_money_check: :完成资金核对, finish_commission_form: :完成提成单填写, finish_leader_check: :完成领导审核}
  end

end