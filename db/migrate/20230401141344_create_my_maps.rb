class CreateMyMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :my_maps do |t|
      t.text :column1
      t.text :column2
      t.binary :image

      t.timestamps
    end
  end
end
