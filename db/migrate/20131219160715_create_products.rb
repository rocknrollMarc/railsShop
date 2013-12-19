class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :text
      t.string :image_url
      t.string :string
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
