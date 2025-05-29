class FoodGroupsController < ApplicationController
  def index
    matching_food_groups = FoodGroup.all

    @list_of_food_groups = matching_food_groups.order({ :created_at => :desc })

    render({ :template => "food_groups/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_food_groups = FoodGroup.where({ :id => the_id })

    @the_food_group = matching_food_groups.at(0)
    @dish_food_groups = DishFoodGroup
    .includes(:dish)
    .where({ :food_group_id => the_id })
    .where("number_of_instances > 0")
    .order("dishes.name ASC")
    
    render({ :template => "food_groups/show" })
  end

  def create
    the_food_group = FoodGroup.new
    the_food_group.name = params.fetch("query_name")

    if the_food_group.valid?
      the_food_group.save
      redirect_to("/food_groups", { :notice => "Food group created successfully." })
    else
      redirect_to("/food_groups", { :alert => the_food_group.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_food_group = FoodGroup.where({ :id => the_id }).at(0)

    the_food_group.name = params.fetch("query_name")

    if the_food_group.valid?
      the_food_group.save
      redirect_to("/food_groups/#{the_food_group.id}", { :notice => "Food group updated successfully."} )
    else
      redirect_to("/food_groups/#{the_food_group.id}", { :alert => the_food_group.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_food_group = FoodGroup.where({ :id => the_id }).at(0)

    the_food_group.destroy

    redirect_to("/food_groups", { :notice => "Food group deleted successfully."} )
  end
end
