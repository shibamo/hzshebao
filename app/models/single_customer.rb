class SingleCustomer < ActiveRecord::Base
	include Workflow
  include ChinesifyWorkflow

	belongs_to :user #归属的业务员
	has_many :customer_id_card_pictures, -> { where(customer_type: "个人客户") } ,foreign_key: :customer_id
  has_many :charges #缴费单
	has_one :renewal #续费状态
  has_one :gongjijin #公积金

	validates_presence_of :name, :gender, :ethnic_name,:education,:birth, :id_no, 
						:id_address, :hukou_type, :tel, :other_contact_person,
						:other_contact_call, :communication_address, message: "字段不能为空"

	validates_uniqueness_of :id_no, message: "身份证号已存在,不能重复创建已有客户"

  default_scope {order(created_at: :desc)}

	scope :created_at_today, -> { where("document_no like :document_no_head",
														document_no_head:  "A"+ Date.today.to_formatted_s(format=:number) + "%") }
	scope :managed_by_users, ->(user_ids) {where(user_id: user_ids).order(:user_id)}

  scope :order_by_users, ->{unscoped.order(:user_id)}

  scope :by_partial_name, ->(partial_name) {where("name like ?", "%#{partial_name}%")}
  
	paginates_per 20             #每页显示n条数据

	before_create do#生成档案编号,如"A201506120001", 其中 1位:固定为"A",2-9位:日期数字,最后四位为流水号
    if self.document_no.length == 0
  		serial_no = (SingleCustomer.created_at_today.count + 1).to_s
      self.document_no = "A"+ Date.today.to_formatted_s(format=:number) + "0"*(4-serial_no.length) + serial_no
    end
  end

  #使用状态机管理状态
  workflow do
  	state :new do #新建
  		event :finish_check, :transitions_to => :checked
  	end

  	state :checked do #复核通过
  		event :finish_apply_start, :transitions_to => :serving
  	end

  	state :serving do #已申报在保
  		event :finish_apply_stop, :transitions_to => :stopped
  	end

  	state :stopped do #已申报停保
  		event :finish_apply_restart, :transitions_to => :serving
  	end
  end
  #状态名与中文名对应表
  WORKFLOW_STATE_NAMES = {new: :新建, checked: :复核通过, serving: :已申报在保, stopped: :已申报停保}
  #事件(操作)名与中文名对应表
  WORKFLOW_EVENT_NAMES = {finish_check: :复核完成, finish_apply_start: :完成申报入保, finish_apply_stop: :完成申报停保, 
                          finish_apply_restart: :重新申报入保}
  
  def service_end_date #服务截止日期,目前已无意义
    self.charges.collect(&:end_date).max
  end

  def shebao_start_date #社保服务开始日期,缴费被确认以后
    self.charges.of_after_money_arrived.minimum(:start_date_shebao)
  end

  def shebao_end_date #社保服务截止日期
    self.charges.maximum(:end_date_shebao)
  end

  def gongjijin_start_date #公积金服务开始日期,缴费被确认以后
    self.charges.of_after_money_arrived.minimum(:start_date_gongjijin)
  end
  
  def gongjijin_end_date #公积金服务截止日期
    self.charges.maximum(:end_date_gongjijin)
  end

  def self.need_start_shebao #计算需要开通社保的客户列表
    #客户处于"已复核(checked)"状态且社保开始日期不为空
    ids = SingleCustomer.with_checked_state.collect {|t| t.id if t.shebao_start_date}.delete_if{|t| t ==nil}
    SingleCustomer.where(id: ids)
  end

  def self.need_renew #计算需要催交续费的客户列表
    #客户处于"已申报在保(serving)"状态且缴费不够覆盖支付到下月底
    ids1 = SingleCustomer.with_serving_state.collect {|t| [t.id, t.charges.maximum(:end_date_shebao)]}.delete_if { |a| a[1].nil? || a[1] > Date.today.next_month.end_of_month }.collect{|a| a[0]} 
    #ids2= Renewal.with_new_state.collect(&:single_customer_id)#客户的续费状态尚处于"服务中-无需续费(new)"状态
    SingleCustomer.where(id: ids1) 
  end

  def self.need_append_shebao #计算需要补交社保的客户列表
    deadline = Date.new(Date.today.year, 6,30) #取每年六月三十号作为判断日
    base = ShebaoBase.where(year: Date.today.year).first.base
    scs = SingleCustomer.all.select do |sc| 
      sc.charges.select {|c| c.months_shebao > 0 and c.price_shebao < base and 
                            c.start_date_shebao and c.start_date_shebao<= deadline and 
                            deadline <= c.end_date_shebao }.count > 0 and 
                            # 交过的社保金额不够且包含了判断日
      sc.charges.select {|c| c.months_bujiao > 0 and c.start_date_bujiao and 
                            c.start_date_bujiao<= deadline and 
                            deadline <= c.end_date_bujiao }.count == 0 # 且未做过补交
    end
    SingleCustomer.where(id: scs.collect(&:id))
  end

  def hukou_type_name(hukou_type)
    { 10 => "本地城镇（主城区）", 11 => "外地城镇（省内市外）", 12 => "外地城镇（省外）", 
      20 => "本地农村（主城区）", 21 => "外地农村（省内市外）", 22 => "外地农村（省外）" }[hukou_type]
  end
end
