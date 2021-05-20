require 'socket'

def parse_request(request_line)
  http_method, path_and_params, = request_line.split(' ')
  path, params_string = path_and_params.split('?')
  params = params_string.split('&').each_with_object({}) do |pair, hash|
    key, value = pair.split('=')
    hash[key] = value
  end
  [http_method, path, params]
end

server = TCPServer.new 8080
loop do
  client = server.accept
  request_line = client.gets
  puts request_line
  next unless request_line
  http_method, path, params = parse_request(request_line)
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts '<html>'
  client.puts '<body>'
  client.puts '<pre>'
  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts '</pre>'
  client.puts '<h1>Rolls!</h1>'
  rolls = params['rolls'].to_i
  sides = params['sides'].to_i
  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>#{roll}</p>"
  end
  client.puts '</body>'
  client.puts '</html>'
  client.close
end
