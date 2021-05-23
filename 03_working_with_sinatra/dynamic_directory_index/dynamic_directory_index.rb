require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
# set :bind, '0.0.0.0'
set :port, 8080

get "/" do
  @sort = params["sort"]
  @files = Dir.glob("public/*.*").map do |path|
    File.basename(path)
  end
  @files.reverse! if @sort == "descending"
  erb :index
end
