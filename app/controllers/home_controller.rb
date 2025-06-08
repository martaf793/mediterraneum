class HomeController < ApplicationController
  def index
    # Step 1: Parse start_date param (default to most recent Monday)
    begin
      parsed_param_date = params[:start_date].presence && Date.parse(params[:start_date])
    rescue ArgumentError
      parsed_param_date = nil
    end

    # Align to Monday of that week (or today if none provided or invalid)
    reference_date = parsed_param_date || Date.today
    @start_date = reference_date - ((reference_date.wday + 6) % 7)

    # Step 2: Load dishes and meals
    matching_dishes = Dish.all
    @list_of_dishes = matching_dishes.where(creator_id: current_user.id).order(created_at: :desc)
    
    matching_assigned_meals = AssignedMeal.all
    @list_of_assigned_meals = matching_assigned_meals.where(user_id: current_user.id, 
                                                 assigned_to: @start_date..(@start_date + 6)).order(:assigned_to)

    @food_groups = FoodGroup.all
    render({ :template => "home/homepage" })
  end
end
