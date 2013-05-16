require 'bundler'

Bundler.require

DataMapper.setup(:default, 'sqlite:///Users/merylcharleston/Documents/mayproject/db/mp.db')

class Post
  include DataMapper::Resource

  property :id,       Serial
  property :title,    String
  property :date,     Date
  property :content,  Text

  has n, :tags

end

class Tag
  include DataMapper::Resource

  property :id,       Serial
  property :category, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

use Rack::Static, :urls => ['/images'], :root => 'public'

get '/style.css' do
	scss :style
end

get '/' do
	haml :index
end

get '/post/new' do
  haml :post_new
end

get '/post/create' do
  post = Post.new(title: params[:title])
end

get '/about' do
	haml :about
end

get '/faq' do
  haml :faq
end