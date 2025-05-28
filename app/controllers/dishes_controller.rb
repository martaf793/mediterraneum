class DishesController < ApplicationController
  def index
    @q=Dish.ransack(params[:q])
    @matching_dishes = @q.result(:distinct => true).includes(:dish_food_groups)
    @list_of_dishes = @matching_dishes.order({ :created_at => :desc })

    matching_assigned_meals = AssignedMeal.all
    @list_of_assigned_meals = matching_assigned_meals.order({ :assigned_to => :asc })
    
    render({ :template => "dishes/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_dishes = Dish.where({ :id => the_id })

    @the_dish = matching_dishes.at(0)

    render({ :template => "dishes/show" })
  end

  def create
    the_dish = Dish.new
    the_dish.name = params.fetch("query_name")
    the_dish.creator_id = params.fetch("query_creator_id")

    if the_dish.valid?
      the_dish.save
      redirect_to("/dishes", { :notice => "Dish created successfully." })
    else
      redirect_to("/dishes#{the_dish.id}", { :alert => the_dish.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_dish = Dish.where({ :id => the_id }).at(0)

    the_dish.name = params.fetch("query_name")
    the_dish.creator_id = params.fetch("query_creator_id")

    if the_dish.valid?
      the_dish.save
      redirect_to("/dishes", { :notice => "Dish updated successfully."} )
    else
      redirect_to("/dishes/#{the_dish.id}", { :alert => the_dish.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_dish = Dish.where({ :id => the_id }).at(0)

    the_dish.destroy

    redirect_to("/dishes", { :notice => "Dish deleted successfully."} )
  end
  def process_inputs
    @the_description = params.fetch("meal_description", "")

    chat = OpenAI::Chat.new
    chat.model = "gpt-4.1-nano"
    chat.system("You are an expert nutritionist. Your job is to assess how many instances of these food groups categories (vegetables, legumes, fish, eggs, white meat, red meat and whole grains) are in a meal.  You should also add notes on how you arrived at these figures, and any other notes you have. The user will provide a description of the meal.")
    chat.schema = '{
      "meal_description": "User-entered string describing the meal",
      "food_group_counts": {
        "vegetables": {
          "count": 0,
          "examples": []
        },
        "legumes": {
          "count": 0,
          "examples": []
        },
        "fish": {
          "count": 0,
          "examples": []
        },
        "eggs": {
          "count": 0,
          "examples": []
        },
        "white_meat": {
          "count": 0,
          "examples": []
        },
        "red_meat": {
          "count": 0,
          "examples": []
        },
        "whole_grains": {
          "count": 0,
          "examples": []
        }
      },

      "notes": "Detailed explanation of how the counts were assessed, ambiguities, or any clarifications (e.g., ingredients that might be borderline).",

      "other_considerations": "General nutrition advice, suggestions for improvement, or additional observations relevant to the meal."
    }'
    if @the_description.blank?
        @notes = "You must provide at least one of image or description."
    else
      if @the_description.present?
        chat.user(@the_description)
      end

      result = chat.assistant!

      @vegetables = result.fetch("vegetables")
      @legumes = result.fetch("legumes")
      @fish = result.fetch("fish")
      @eggs = result.fetch("eggs")
      @white_meat = result.fetch("white_meat")
      @red_meat = result.fetch("red_meat")
      @whole_grains = result.fetch("whole_grains")
      @notes = result.fetch("notes")
  
    end

    render({ :template => "dishes/index" })
  end 
  
end
