module FileField #文件上传处理的通用模块
	extend ActiveSupport::Concern


	def uploaded_file=(file_field)
    self.file_name    = base_part_of(file_field.original_filename)
    self.content_type = file_field.content_type.chomp
    self.file_raw     = file_field.read
  end

  def base_part_of(file_name)
    File.basename(file_name)
    #.gsub(/[^\w._-]/, '')
  end
end