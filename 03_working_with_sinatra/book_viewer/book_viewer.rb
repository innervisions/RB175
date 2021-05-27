require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
set :bind, '0.0.0.0'
set :port, 8080

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  redirect "/" unless (1..@contents.size).cover?(number)
  @title = "#{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")
  erb :chapter
end

def each_chapter
  @contents.each_with_index do |name, idx|
    number = idx + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = {}
  return results if !query || query.empty?
  each_chapter do |number, name, contents|
    contents.split("\n\n").each_with_index do |paragraph, idx|
      if paragraph.include?(query)
        results[name] ||= []
        results[name] << { number: number, paragraph: paragraph, id: idx + 1 }
      end
    end
  end
  results
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    id = 0
    text.split("\n\n").map do |paragraph|
      id += 1
      "<p id=#{id}>#{paragraph}</p>"
    end.join
  end

  def highlight_match(text, match)
    text.gsub(match, "<strong>#{match}</strong>")
  end
end
