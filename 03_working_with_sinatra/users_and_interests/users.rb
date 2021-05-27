require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "YAML"
set :bind, '0.0.0.0'
set :port, 8080

before do
  @users = YAML.load_file("users.yaml")
end

helpers do
  def total_interests
    @users.sum { |_, v| v[:interests].size }
  end
end

get "/" do
  redirect "/users"
end

get "/users" do
  erb :users
end

get "/:user_name" do
  @user_name = params[:user_name].to_sym
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]
  erb :user
end
