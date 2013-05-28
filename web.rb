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
  property :content,    Text
  property :tag,        String
  property :datetime,   DateTime

  mount_uploader :image, PostpicUploader

  has n, :tags, :through => Resource

end


class Tag
  include DataMapper::Resource

  property :id,       Serial
  property :category, String

  has n, :posts, :through => Resource
end

DataMapper.finalize
DataMapper.auto_upgrade!

use Rack::Static, :urls => ['/images'], :root => 'public'

get '/style.css' do
	scss :style
end

get '/' do
  @pagetitle = "May Project"
  @posts = Post.all(:order => :datetime.desc)

	haml :index
end

get '/post/new' do
  @pagetitle = "New Post"
  haml :post_new
  #"Hello, world!"
end

get '/post/:id/edit' do
  @pagetitle = "Edit Post"
  @post = Post.get(params[:id])
  haml :post_edit
end

put '/post/:id' do
  @post = Post.get(params[:id])
  if @post.update(params[:post])
    status 201
    redirect '/'
  else
    redirect '/post/#{@post.id}/edit'
  end
end

get '/post/:id' do
  @pagetitle = "Post #{params[:id]}"
  @post = Post.get(params[:id])
  haml :post_id
end

delete '/post/:id' do
  Post.get(params[:id]).destroy
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

get '/commute' do
  @pagetitle = "My Daily Commute"
	haml :commute
end

get '/faq' do
  @pagetitle = "FAQ"
  haml :faq
end