class DishFoodGroupsController < ApplicationController
  def index
    matching_dish_food_groups = DishFoodGroup.all

    @list_of_dish_food_groups = matching_dish_food_groups.order({ :created_at => :desc })

    render({ :template => "dish_food_groups/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_dish_food_groups = DishFoodGroup.where({ :id => the_id })

    @the_dish_food_group = matching_dish_food_groups.at(0)

    render({ :template => "dish_food_groups/show" })
  end

  def create
    the_dish_food_group = DishFoodGroup.new
    the_dish_food_group.dish_id = params.fetch("query_dish_id")
    the_dish_food_group.food_group_id = params.fetch("query_food_group_id")
    the_dish_food_group.number_of_instances = params.fetch("query_number_of_instances")

    if the_dish_food_group.valid?
      the_dish_food_group.save
      redirect_to("/dish_food_groups", { :notice => "Dish food group created successfully." })
    else
      redirect_to("/dish_food_groups", { :alert => the_dish_food_group.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_dish_food_group = DishFoodGroup.where({ :id => the_id }).at(0)

    the_dish_food_group.dish_id = params.fetch("query_dish_id")
    the_dish_food_group.food_group_id = params.fetch("query_food_group_id")
    the_dish_food_group.number_of_instances = params.fetch("query_number_of_instances")

    if the_dish_food_group.valid?
      the_dish_food_group.save
      redirect_to("/dish_food_groups/#{the_dish_food_group.id}", { :notice => "Dish food group updated successfully."} )
    else
      redirect_to("/dish_food_groups/#{the_dish_food_group.id}", { :alert => the_dish_food_group.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_dish_food_group = DishFoodGroup.where({ :id => the_id }).at(0)

    the_dish_food_group.destroy

    redirect_to("/dish_food_groups", { :notice => "Dish food group deleted successfully."} )
  end
end
