module ModelHelper
  extend ActiveSupport::Concern

  def batch_set_nil_property_value(value,*properties)
    properties.each do |property|
      self.send("#{property}=", value) if self.send("#{property}").nil?
    end
  end
end