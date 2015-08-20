class AddQueryIndexToMoneyArrivalFiles < ActiveRecord::Migration
  def change
  	#add_index(table_name, column_names, options): Adds a new index with the name of the column. 
  	#Other options include :name, :unique (e.g. { name: 'users_name_index', unique: true }) and
  	# :order (e.g. { order: { name: :desc } }).
  	add_index :money_arrival_files, [:business_type, :main_object_id, :extra_data, :business_action], name: :idx_query_1
  end
end
