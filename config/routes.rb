Rails.application.routes.draw do

  get("/",{ :controller => "dish_food_groups", :action => "index" })

  # Routes for the Assigned meal resource:

  # CREATE
  post("/insert_assigned_meal", { :controller => "assigned_meals", :action => "create" })
          
  # READ
  get("/assigned_meals", { :controller => "assigned_meals", :action => "index" })
  
  get("/assigned_meals/:path_id", { :controller => "assigned_meals", :action => "show" })
  
  # UPDATE
  
  post("/modify_assigned_meal/:path_id", { :controller => "assigned_meals", :action => "update" })
  
  # DELETE
  get("/delete_assigned_meal/:path_id", { :controller => "assigned_meals", :action => "destroy" })

  #------------------------------

  devise_for :users

  # Routes for the Dish food group resource:

  # CREATE
  post("/insert_dish_food_group", { :controller => "dish_food_groups", :action => "create" })
          
  # READ
  get("/dish_food_groups", { :controller => "dish_food_groups", :action => "index" })
  
  get("/dish_food_groups/:path_id", { :controller => "dish_food_groups", :action => "show" })
  
  # UPDATE
  
  post("/modify_dish_food_group/:path_id", { :controller => "dish_food_groups", :action => "update" })
  
  # DELETE
  get("/delete_dish_food_group/:path_id", { :controller => "dish_food_groups", :action => "destroy" })

  #------------------------------

  # Routes for the Food group resource:

  # CREATE
  post("/insert_food_group", { :controller => "food_groups", :action => "create" })
          
  # READ
  get("/food_groups", { :controller => "food_groups", :action => "index" })
  
  get("/food_groups/:path_id", { :controller => "food_groups", :action => "show" })
  
  # UPDATE
  
  post("/modify_food_group/:path_id", { :controller => "food_groups", :action => "update" })
  
  # DELETE
  get("/delete_food_group/:path_id", { :controller => "food_groups", :action => "destroy" })

  #------------------------------

  # Routes for the Dish resource:

  # CREATE
  post("/insert_dish", { :controller => "dishes", :action => "create" })
          
  # READ
  get("/dishes", { :controller => "dishes", :action => "index" })
  
  get("/dishes/:path_id", { :controller => "dishes", :action => "show" })
  
  # UPDATE
  
  post("/modify_dish/:path_id", { :controller => "dishes", :action => "update" })
  
  # DELETE
  get("/delete_dish/:path_id", { :controller => "dishes", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
