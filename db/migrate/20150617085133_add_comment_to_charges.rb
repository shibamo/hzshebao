class AddCommentToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :comment, :text
  end
end
