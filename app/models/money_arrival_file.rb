class MoneyArrivalFile < ActiveRecord::Base
	belongs_to :charge, foreign_key: 'main_object_id', polymorphic: true, foreign_type: 'business_type'

	validates_presence_of :file_raw,   message: "文件不能为空"

	validates_length_of :file_raw, maximum: 1024*1024, message: "文件超过长度,单个文件不能超过1兆"

	scope :managed_by_users, ->(user_ids) {where(user_id: user_ids)}

	scope :business_files, ->(business_type, main_object_id,extra_data,business_action) {
															where(business_type: business_type, main_object_id: main_object_id,
																extra_data: extra_data, business_action: business_action)}
	
	include FileField
	
end
