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

  def process_inputs
    # 1) Grab the meal description and creator, then save a new Dish
    the_dish = Dish.new
    the_dish.name       = params.fetch("ai_query_name", "")
    the_dish.creator_id = params.fetch("query_creator_id")
    if the_dish.valid?
      the_dish.save
    else
      @alert="Provide a meal description"
    end

    # 2) Re-build everything that index needs
    @q                  = Dish.ransack(params[:q])
    @matching_dishes    = @q.result({ :distinct => true })
                             .includes(:dish_food_groups)
    @list_of_dishes     = @matching_dishes.order({ :created_at => :desc })
    @list_of_assigned_meals =
      AssignedMeal.all.order({ :assigned_to => :asc })

    @the_description = params.fetch("ai_query_name", "")

    if @the_description.blank?
      @notes = "You must provide a description."
    else
      require "http"
      require "json"
      # Build the Chat Completions request
      body_hash = {
        "model"    => "gpt-3.5-turbo",
        "messages" => [
          {
            "role"    => "system",
            "content" =>
              "You are an expert nutritionist. " \
              "Given a meal description, return JSON with this schema:\n" \
              "{\"food_group_counts\":{" \
                "\"vegetables\":{\"count\":0},\"legumes\":{\"count\":0}," \
                "\"fish\":{\"count\":0},\"eggs\":{\"count\":0}," \
                "\"white_meat\":{\"count\":0},\"red_meat\":{\"count\":0}," \
                "\"whole_grains\":{\"count\":0}" \
              "}," \
              "\"notes\":\"string\"}"
          },
          {
            "role"    => "user",
            "content" => @the_description
          }
        ]
      }

      raw = HTTP.auth("Bearer #{ENV.fetch("OPENAI_TOKEN")}")
                .post(
                  "https://api.openai.com/v1/chat/completions",
                  :json => body_hash
                )
                .to_s

      parsed = JSON.parse(raw)

      # Drill into the first choice's message
      content = parsed
                  .fetch("choices")
                  .at(0)
                  .fetch("message")
                  .fetch("content")

      # Parse the assistant’s JSON reply
      structured = JSON.parse(content)
      @fg         = structured.fetch("food_group_counts")

      @vegetables   = @fg.fetch("vegetables").fetch("count")
      @legumes      = @fg.fetch("legumes").fetch("count")
      @fish         = @fg.fetch("fish").fetch("count")
      @eggs         = @fg.fetch("eggs").fetch("count")
      @white_meat   = @fg.fetch("white_meat").fetch("count")
      @red_meat     = @fg.fetch("red_meat").fetch("count")
      @whole_grains = @fg.fetch("whole_grains").fetch("count")
      @notes        = structured.fetch("notes")
    end

    render({ :template => "dishes/index" })
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
  
end
