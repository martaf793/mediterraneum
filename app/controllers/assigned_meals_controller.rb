class AssignedMealsController < ApplicationController
  def index
    matching_assigned_meals = AssignedMeal.all

    @list_of_assigned_meals = matching_assigned_meals.order({ :created_at => :desc })

    render({ :template => "assigned_meals/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_assigned_meals = AssignedMeal.where({ :id => the_id })

    @the_assigned_meal = matching_assigned_meals.at(0)

    render({ :template => "assigned_meals/show" })
  end

  def create
    the_assigned_meal = AssignedMeal.new
    the_assigned_meal.dish_id = params.fetch("query_dish_id")
    the_assigned_meal.assigned_to = params.fetch("query_assigned_to")
    the_assigned_meal.user_id = params.fetch("query_user_id")

    if the_assigned_meal.valid?
      the_assigned_meal.save
      redirect_to("/assigned_meals", { :notice => "Assigned meal created successfully." })
    else
      redirect_to("/assigned_meals", { :alert => the_assigned_meal.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_assigned_meal = AssignedMeal.where({ :id => the_id }).at(0)

    the_assigned_meal.dish_id = params.fetch("query_dish_id")
    the_assigned_meal.assigned_to = params.fetch("query_assigned_to")
    the_assigned_meal.user_id = params.fetch("query_user_id")

    if the_assigned_meal.valid?
      the_assigned_meal.save
      redirect_to("/assigned_meals/#{the_assigned_meal.id}", { :notice => "Assigned meal updated successfully."} )
    else
      redirect_to("/assigned_meals/#{the_assigned_meal.id}", { :alert => the_assigned_meal.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_assigned_meal = AssignedMeal.where({ :id => the_id }).at(0)

    the_assigned_meal.destroy

    redirect_to("/assigned_meals", { :notice => "Assigned meal deleted successfully."} )
  end
end
