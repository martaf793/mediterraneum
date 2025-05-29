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
    @the_description = params.fetch("query_name", "")

    if @the_description.blank?
      @notes = "You must provide a description."
    else
      require "http"
      require "json"
      client = OpenAI::Client.new({ :access_token => ENV.fetch("OPENAI_TOKEN") })

      messages_array = [
        {
          role: "system",
          content: "You are an expert nutritionist. Your job is to assess how many instances of these food group categories (vegetables, legumes, fish, eggs, white meat, red meat and whole grains) are in a meal. The user will provide a description of the meal. Respond in valid JSON according to the provided schema."
        },
        {
          role: "user",
          content: @the_description
        }
      ]

      schema = {
        "type": "object",
        "properties": {
          "food_group_counts": {
            "type": "object",
            "properties": {
              "vegetables": { "type": "object", "properties": { "count": { "type": "integer" } } },
              "legumes":    { "type": "object", "properties": { "count": { "type": "integer" } } },
              "fish":       { "type": "object", "properties": { "count": { "type": "integer" } } },
              "eggs":       { "type": "object", "properties": { "count": { "type": "integer" } } },
              "white_meat": { "type": "object", "properties": { "count": { "type": "integer" } } },
              "red_meat":   { "type": "object", "properties": { "count": { "type": "integer" } } },
              "whole_grains": { "type": "object", "properties": { "count": { "type": "integer" } } }
            }
          },
          "notes": { "type": "string" }
        },
        "required": ["food_group_counts", "notes"]
      }
      response_format = {
        type: "json_schema",
        json_schema: schema
      }

      request_headers_hash = {
        "Authorization" => "Bearer #{ENV.fetch("OPENAI_TOKEN")}",
        "content-type" => "application/json"
      }
      request_body = {
        "model" =>"gpt-4o",
        "messages" => messages_array,
        "response_format" => response_format
      }
      request_body_json = JSON.generate(request_body)

      raw_response = HTTP.headers(request_headers_hash).post(
        "https://api.openai.com/v1/chat/completions",
        :body => request_body_json
      ).to_s
      pp raw_response
      parsed_response = JSON.parse(raw_response)
      pp parsed_response
      message_content = parsed_response.dig("choices", 0, "message", "content")
      

      structured_output = JSON.parse(message_content)
      fg     = structured_output.fetch("food_group_counts")

        @vegetables   = fg.fetch("vegetables").fetch("count")
        @legumes      = fg.fetch("legumes").fetch("count")
        @fish         = fg.fetch("fish").fetch("count")
        @eggs         = fg.fetch("eggs").fetch("count")
        @white_meat   = fg.fetch("white_meat").fetch("count")
        @red_meat     = fg.fetch("red_meat").fetch("count")
        @whole_grains = fg.fetch("whole_grains").fetch("count")
  
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
