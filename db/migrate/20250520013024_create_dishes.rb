class CreateDishes < ActiveRecord::Migration[7.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.integer :creator_id

      t.timestamps
    end
  end
end
