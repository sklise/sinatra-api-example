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
  send_file './public/index.html'
end

# Route to show all Things, ordered like a blog
get '/things' do
  content_type :json
  @things = Thing.all(:order => :created_at.desc)

  @things.to_json
end

# CREATE: Route to create a new Thing
post '/things' do
  content_type :json
  # JSON is sent in the body of the http request. We need to parse the body
  # from a string into JSON
  params_json = JSON.parse(request.body.read)

  @thing = Thing.new(params_json)

  if @thing.save
    @thing.to_json
  else
    halt 500
  end
end

# READ: Route to show a specific Thing based on its `id`
get '/things/:id' do
  content_type :json
  @thing = Thing.get(params[:id])

  if @thing
    @thing.to_json
  else
    halt 404
  end
end

# UPDATE: Route to update a Thing
put '/things/:id' do
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

# DELETE: Route to delete a Thing
delete '/things/:id/delete' do
  content_type :json
  @thing = Thing.get(params[:id])

  if @thing.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end

# If there are no Things in the database, add a few.
if Thing.count == 0
  Thing.create(:title => "Test Thing One", :description => "Sometimes I eat pizza.")
  Thing.create(:title => "Test Thing Two", :description => "Other times I eat cookies.")
end