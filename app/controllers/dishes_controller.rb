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
    the_dish            = Dish.new
    the_dish.name       = params.fetch("ai_query_name")
    the_dish.creator_id = params.fetch("query_creator_id")

    if the_dish.valid?
      the_dish.save
      require "http"
      require "json"
      schema = {
        "type" => "object",
        "properties" => {
          "food_group_counts" => {
            "type" => "object",
            "properties" => {
              "vegetables"   => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } },
              "legumes"      => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } },
              "fish"         => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } },
              "eggs"         => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } },
              "white_meat"   => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } },
              "red_meat"     => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } },
              "whole_grains" => { "type" => "object", "properties" => { "count" => { "type" => "integer" } } }
            }
          },
          "notes" => { "type" => "string" }
        },
        "required" => ["food_group_counts", "notes"]
      }

      body_hash = {
        "model"    => "gpt-3.5-turbo",
        "messages" => [
          {
            "role"    => "system",
            "content" =>
              "You are an expert nutritionist. Your job is to assess how many instances of these food group categories (vegetables, legumes, fish, eggs, white meat, red meat and whole grains) are in a meal. The user will provide a description of the meal. Respond in valid JSON according to the provided schema." \
              "#{JSON.generate(schema)}"
          },
          {
            "role"    => "user",
            "content" => the_dish.name
          }
        ]
      }

      raw_response    = HTTP.auth("Bearer #{ENV.fetch("OPENAI_TOKEN")}")
                          .post(
                            "https://api.openai.com/v1/chat/completions",
                            :json => body_hash
                          )
                          .to_s
      parsed_response = JSON.parse(raw_response)

      content           = parsed_response
                            .fetch("choices")
                            .at(0)
                            .fetch("message")
                            .fetch("content")
      structured_output = JSON.parse(content)
      fg_counts         = structured_output.fetch("food_group_counts")

      

      # 3) persist each count into the join table
      fg_counts.each do |fg_key, fg_data|
        # map "white_meat" → "white meat"  etc, to match your FoodGroup.name
        group_name      = fg_key.tr("_", " ")
        matching_groups = FoodGroup.where({ :name => group_name })
        the_group       = matching_groups.at(0)
        next unless the_group

        dfg = DishFoodGroup.new
        dfg.dish_id             = the_dish.id
        dfg.food_group_id       = the_group.id
        dfg.number_of_instances = fg_data.fetch("count")
        dfg.save
      end

      flash[:notice] = "Dish created and analyzed!"
    else
      flash[:alert] = the_dish.errors.full_messages.to_sentence
    end

    @q               = Dish.ransack(params[:q])
    @matching_dishes = @q.result({ :distinct => true })
                        .includes(:dish_food_groups)
    @list_of_dishes  = @matching_dishes.order({ :created_at => :desc })
    @list_of_assigned_meals =
      AssignedMeal.all.order({ :assigned_to => :asc })

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
