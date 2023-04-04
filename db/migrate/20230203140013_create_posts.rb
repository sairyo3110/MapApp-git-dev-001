class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :content

      t.timestamps
      add_column :posts, :address, :string
      add_column :posts, :latitude, :float
      add_column :posts, :longitude, :float
    end
  end
end
