class CreateAssignedMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :assigned_meals do |t|
      t.integer :dish_id
      t.date :assigned_to
      t.integer :user_id

      t.timestamps
    end
  end
end
