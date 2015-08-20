class ShebaoBase < ActiveRecord::Base
	belongs_to :user

	validates_uniqueness_of :year, message: "该年的记录已存在"
	validates_presence_of :year, :base, message: "字段不能为空"

	default_scope { order(year: :desc) }
end
