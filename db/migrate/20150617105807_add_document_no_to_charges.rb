class AddDocumentNoToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :document_no, :string
  end
end
