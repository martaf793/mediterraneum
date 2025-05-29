# require "http"
# require "json"
# require "awesome_print"
# @the_description = "salmon"

#     if @the_description.blank?
#       @notes = "You must provide a description."
#     else
#       client = OpenAI::Client.new({ :access_token => ENV.fetch("OPENAI_TOKEN") })

#       messages_array = [
#         {
#           role: "system",
#           content: "You are an expert nutritionist. Your job is to assess how many instances of these food group categories (vegetables, legumes, fish, eggs, white meat, red meat and whole grains) are in a meal. The user will provide a description of the meal. Respond in valid JSON according to the provided schema."
#         },
#         {
#           role: "user",
#           content: @the_description
#         }
#       ]

#       schema = {
#         "type": "object",
#         "properties": {
#           "food_group_counts": {
#             "type": "object",
#             "properties": {
#               "vegetables": { "type": "object", "properties": { "count": { "type": "integer" } } },
#               "legumes":    { "type": "object", "properties": { "count": { "type": "integer" } } },
#               "fish":       { "type": "object", "properties": { "count": { "type": "integer" } } },
#               "eggs":       { "type": "object", "properties": { "count": { "type": "integer" } } },
#               "white_meat": { "type": "object", "properties": { "count": { "type": "integer" } } },
#               "red_meat":   { "type": "object", "properties": { "count": { "type": "integer" } } },
#               "whole_grains": { "type": "object", "properties": { "count": { "type": "integer" } } }
#             }
#           },
#           "notes": { "type": "string" }
#         },
#         "required": ["food_group_counts", "notes"]
#       }
#       response_format = {
#         type: "json_schema",
#         json_schema: schema
#       }

#       request_headers_hash = {
#         "Authorization" => "Bearer #{ENV.fetch("OPENAI_TOKEN")}",
#         "content-type" => "application/json"
#       }
#       request_body = {
#         "model" =>"gpt-4o",
#         "messages" => messages_array,
#         "response_format" => response_format
#       }
#       request_body_json = JSON.generate(request_body)

#       raw_response = HTTP.headers(request_headers_hash).post(
#         "https://api.openai.com/v1/chat/completions",
#         :body => request_body_json
#       ).to_s

#       parsed_response = JSON.parse(raw_response)

#       message_content = parsed_response.dig("choices", 0, "message", "content")

#       structured_output = JSON.parse(message_content)
#       fg     = structured_output.fetch("food_group_counts")

#         @vegetables   = fg.fetch("vegetables").fetch("count")
#         @legumes      = fg.fetch("legumes").fetch("count")
#         @fish         = fg.fetch("fish").fetch("count")
#         @eggs         = fg.fetch("eggs").fetch("count")
#         @white_meat   = fg.fetch("white_meat").fetch("count")
#         @red_meat     = fg.fetch("red_meat").fetch("count")
#         @whole_grains = fg.fetch("whole_grains").fetch("count")
  
#     end
