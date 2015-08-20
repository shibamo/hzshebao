class Contract < ActiveRecord::Base
	include DateLineCompare
	belongs_to :single_customer
	belongs_to :user

	default_scope {order(created_at: :desc)}
	validates_presence_of :start_date, :end_date, :work, :salary, :location, message: "字段不能为空"

	scope :of_same_customer, ->(single_customer_id) { where(single_customer_id: single_customer_id) }

	scope :managed_by_users, ->(user_ids) {where(user_id: user_ids)}

	def validate_date(start_date,end_date,single_customer_id,skip_contract_id)
		contracts = Contract.of_same_customer(single_customer_id).where.not(id: skip_contract_id)
		contracts.each do |contract|
			if is_overlap(start_date, end_date, contract.start_date,contract.end_date)
				errors[:base] << "日期校验失败,与已有合同日期重叠!"
				return false
			end
		end
	end
end
