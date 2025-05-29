class HomeController < ApplicationController
    def index
    matching_dishes = Dish.all
    @list_of_dishes = matching_dishes.where(creator_id: current_user.id).order({ :created_at => :desc })

    matching_assigned_meals = AssignedMeal.all
    @list_of_assigned_meals = matching_assigned_meals.where(user_id: current_user.id).order({ :assigned_to => :asc })

    @food_groups = FoodGroup.all
    render({ :template => "home/homepage" })
  end
end
