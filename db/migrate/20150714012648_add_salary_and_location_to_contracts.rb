class AddSalaryAndLocationToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :salary, :string
    add_column :contracts, :location, :string
  end
end
