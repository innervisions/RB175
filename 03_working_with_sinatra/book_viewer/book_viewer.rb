require "sinatra"
require "sinatra/reloader"
set :bind, '0.0.0.0'
set :port, 8080

get "/" do
  File.read "public/template.html"
end
