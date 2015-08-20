class AddCommentForQitaToSingleCustomers < ActiveRecord::Migration
  def change
    add_column :single_customers, :comment_for_qita, :string
  end
end
