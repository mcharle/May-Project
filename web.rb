require 'bundler'

Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'])

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
<<<<<<< HEAD
    :aws_access_key_id      => ENV['S3_ACCESS_KEY'],                        # required
    :aws_secret_access_key  => ENV['S3_SECURITY_ACCESS_KEY'],                        # required
=======
    :aws_access_key_id      => 'AKIAJQSKL6FOIY2CSCSQ',                        # required
    :aws_secret_access_key  => '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',                        # required
>>>>>>> 4aade0dccbec4c7d99c93aa407fbbbcde45a36d2
  }
  config.fog_directory  = 'mayproject'                     # required
end

class PostpicUploader < CarrierWave::Uploader::Base
  storage :fog
end

class Post
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :content,    Text
  property :datetime,   DateTime

  mount_uploader :image, PostpicUploader

  def formatted_date
    datetime.strftime('%m/%d/%Y') if datetime
  end
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

get '/post/:id/admin' do
  @pagetitle = "Post #{params[:id]}"
  @post = Post.get(params[:id])
  haml :admin
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

get '/map' do
  haml :temp
end

get '/commute' do
  @pagetitle = "My Daily Commute"
	haml :commute
end

get '/faq' do
  @pagetitle = "FAQ"
  haml :faq
end