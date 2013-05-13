require 'sinatra'
require 'sass'

use Rack::Static, :urls => ['/images'], :root => 'public'


get '/style.css' do
	scss :style
end

get '/' do
	haml :index
end

get '/about' do
	haml :about
end