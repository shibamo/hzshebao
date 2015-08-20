class Charge < ActiveRecord::Base
	include Workflow
  include ChinesifyWorkflow

	belongs_to :single_customer
	belongs_to :user
  has_one :money_arrival_file, foreign_key: 'main_object_id', foreign_type: 'business_type'

	#validates :document_no, uniqueness: {message: "档案编号需要是唯一的,请重新提交."}
  #validates_presence_of :start_date, :end_date, message: "字段不能为空" #这两个字段已经作废,被分散到每个收费品种中
  validates_presence_of :charge_type, :price_shebao, :months_shebao, :price_gongjijin, :months_gongjijin,
                        :price_fuwufei, :months_fuwufei, :price_cailiaofei, :months_cailiaofei,
                        :price_bujiao, :months_bujiao,   message: "字段不能为空"

  default_scope {order(created_at: :desc)}

	scope :created_at_today, -> { where("document_no like :document_no_head",
														document_no_head:  "A"+ Date.today.to_formatted_s(format=:number) + "%") }
	scope :of_same_customer, ->(single_customer_id) { where(single_customer_id: single_customer_id) }

  scope :managed_by_users, ->(user_ids) {where(user_id: user_ids)}

  scope :of_customer_name_like, ->(partial_name) { joins(:single_customer).where("single_customers.name like :partial_name",
                                                                            partial_name: '%' + partial_name + '%')}
  scope :of_money_arrival_date_from, ->(money_arrival_date_from) { where(":money_arrival_date_from <= money_arrival_date",
                                                                    money_arrival_date_from:  money_arrival_date_from)}
  scope :of_money_arrival_date_to, ->(money_arrival_date_to) { where("money_arrival_date <= :money_arrival_date_to", 
                                                                    money_arrival_date_to:  money_arrival_date_to)}
  scope :of_money_check_date_from, ->(money_check_date_from) { where(":money_check_date_from <= money_check_date",
                                                                    money_check_date_from:  money_check_date_from)}
  scope :of_money_check_date_to, ->(money_check_date_to) { where("money_check_date <= :money_check_date_to", 
                                                                    money_check_date_to:  money_check_date_to)}  
  scope :of_workflow_state, ->(workflow_state) {where(workflow_state: workflow_state)}

  scope :of_charge_type, ->(charge_type) {where(charge_type: charge_type)}

  scope :of_after_money_arrived, -> {where(workflow_state: [:money_arrived,:commission_finished,:leader_check_finished])}


	before_create do
		#生成档案编号,如"A201506120001", 其中 1位:固定为"A",2-9位:日期数字,最后四位为流水号
		serial_no = (Charge.created_at_today.count + 1).to_s
    self.document_no = "A"+ Date.today.to_formatted_s(format=:number) + "0"*(4-serial_no.length) + serial_no
  end
	
  paginates_per 20             #每页显示n条数据

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

  def self.charge_types
    [["现金","现金"],["银行转账","银行转账"],["停缴","停缴"],["刷卡","刷卡"]]
  end

  def money_total
    price_shebao*months_shebao + price_gongjijin*months_gongjijin + price_fuwufei*months_fuwufei + 
    price_cailiaofei*months_cailiaofei + price_bujiao*months_bujiao +
    price_geshui*months_geshui + price_chajia*months_chajia
  end
end

