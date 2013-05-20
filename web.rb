require 'bundler'

Bundler.require

DataMapper.setup(:default, 'sqlite:///Users/merylcharleston/Documents/mayproject/db/mp.db')

#require_relative "lib/postpic_uploader"

class PostpicUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    'uploads'
  end
end

class Post
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :date,       Date
  property :content,    Text
  property :tag,       String
  
  mount_uploader :image, PostpicUploader

  has n, :posts, :through => Resource

end


class Tag
  include DataMapper::Resource

  property :id,       Serial
  property :category, String

  has n, :tags, :through => Resource
end

DataMapper.finalize
DataMapper.auto_upgrade!

use Rack::Static, :urls => ['/images'], :root => 'public'

get '/style.css' do
	scss :style
end

get '/' do
  @pagetitle = "May Project"
  @posts = Post.all(:order => :date.desc)

	haml :index
end

get '/post/new' do
  haml :post_new
  #"Hello, world!"
end

get '/post/:id/edit' do
  @post = Post.get(params[:id])
  haml :post_edit
end

put '/post/:id' do
  @post = Post.find(params[:id]).first
  if @post.update(params[:post])
    status 201
    redirect '/'
  else
    redirect '/post/#{@post.id}/edit'
  end
end

get '/post/:id' do
  @post = Post.get(params[:id])
  haml :post_id
end

delete '/post/:id' do
  Post.find(params[:id]).first.destroy
  redirect '/'
end

post '/post/create' do
  post = Post.new(params)

  if post.save
    status 201
    redirect '/'
  else
    redirect '/post/new'
  end
end

get '/about' do
	haml :about
end

get '/faq' do
  haml :faq
end