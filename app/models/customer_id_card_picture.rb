class CustomerIdCardPicture < ActiveRecord::Base
	belongs_to :single_customer

	scope :managed_by_users, ->(user_ids) {where(user_id: user_ids)}

	validates_presence_of :file_raw, presence: true,  message: "文件不能为空"
	validates_length_of :file_raw, maximum: 1024*1024, message: "文件超过长度,单个文件不能超过1兆"

  include FileField
end
