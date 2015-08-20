module DateLineCompare
	extend ActiveSupport::Concern

	private
		#算法参见http://blog.csdn.net/romandion/article/details/8910458
		def is_overlap(date_begin_1,date_end_1,date_begin_2,date_end_2)
			min_date(date_end_1,date_end_2)-max_date(date_begin_1,date_begin_2) >= 0
		end

		def min_date(date1,date2)
			date1-date2<0 ? date1 : date2
		end

		def max_date(date1,date2)
			date1-date2>0 ? date1 : date2
		end
end