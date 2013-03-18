# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
Bundler.require

# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be
# set, when working locally this line will fall back to using SQLite in the
# current directory.
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

# Define a simple DataMapper model.
class Thing
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :created_at, DateTime
  property :title, String, :length => 255
  property :description, Text
end

# Finalize the DataMapper models.
DataMapper.finalize

# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!

get '/' do
  "API Example"
end

# Route to show all Things, ordered like a blog
get '/things' do
  content_type :json
  @things = Thing.all(:order => :created_at.desc)

  @things.to_json
end

# Route to create a new Thing
post '/things' do
  content_type :json
  @thing = Thing.new(params)
  if @thing.save
    @thing.to_json
  else
    halt 500
  end
end

# Route to show a specific Thing based on its `id`
get '/things/:id' do
  content_type :json
  @thing = Thing.get(params[:id])

  if @thing
    @thing.to_json
  else
    halt 404
  end
end

# Route to update a Thing
post '/things/:id/update' do
  content_type :json
  params_json = JSON.parse(request.body.read)

  @thing = Thing.get(params[:id])
  @thing.update(params_json)

  if @thing.save
    @thing.to_json
  else
    halt 500
  end
end

# Route to delete a Thing
get '/things/:id/delete' do
  content_type :json
  @thing = Thing.get(params[:id])

  if @thing.destroy
    {success: "ok"}.to_json
  else
    halt 500
  end
end
