module PagerHelper
  extend ActiveSupport::Concern

  included do
    #对由数据模型对象构成的Array进行封装,通过数据库查询id集合的方式返回结果集,否则前台分页机制无法工作(需要基于结果集)
    def self.wrap_for_paging(model_class, obj_collection)
      model_class.where(id: obj_collection.collect(&:id))
    end
  end
end