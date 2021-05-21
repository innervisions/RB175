require_relative 'advice'

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      template = File.read('views/index.erb')
      content = ERB.new(template)
      ['200', { 'Content-Type' => 'text/html' }, [content.result]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      ['200',
       { 'Content-Type' => 'text/html' },
       ["<b><em>#{piece_of_advice}</em></b>"]]
    else
      ['404',
       { 'Content-Type' => 'text/html', 'Content-Length' => '22' },
       ['<h4>404 Not Found</h4>']]
    end
  end
end
