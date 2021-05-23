require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
# set :bind, '0.0.0.0'
set :port, 8080

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.read("data/chp1.txt")
  erb :chapter
end
