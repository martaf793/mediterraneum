class HomeController < ApplicationController
    def index
    matching_dishes = Dish.all
    @list_of_dishes = matching_dishes.order({ :created_at => :desc })

    matching_assigned_meals = AssignedMeal.all
    @list_of_assigned_meals = matching_assigned_meals.order({ :assigned_to => :asc })
    
    render({ :template => "home/homepage" })
  end
end
