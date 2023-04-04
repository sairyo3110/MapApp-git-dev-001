class AddAddressToMaps < ActiveRecord::Migration[7.0]
  def change
    add_column :maps, :address, :string
  end
end
