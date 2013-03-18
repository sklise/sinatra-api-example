# Sinatra-Heroku Template

## Getting this Working on Your Computer

1. Download this repository and unzip.

2. Install [RVM](https://rvm.io/rvm/install/), it's the best way to install
Ruby on your computer and prevent anything you do with Ruby from messing up
your system.

3. When you have installed RVM, open Terminal and direct the terminal to where
you downloaded this repository, like so:

        $ cd PLACE_YOU_DOWNLOADED_AND_UNZIPPED_THIS_REPOSITORY

4. Now we must install the gems. Gems are what Ruby calls libraries. To do so
we need to install a different gem first:

        $ gem install bundler
        $ bundle install --without production

5. To run the app, use the following command:

        $ bundle exec rackup
This command creates a server on your computer running at
`http://localhost:9292`. Type that in to a web browser on your computer and you
 should see the contents of `views/index.erb`.

6. When you change any code in `app.rb` you'll need to restart the server.
To stop the server type "CTRL+C" in Terminal. and then repeat step 5.

## Heroku App Creation

To create a Heroku app, first be sure you are [signed up](https://api.heroku.com/signup).

Install the Heroku gem (may require `sudo`):

    gem install heroku

Then type the following in Terminal while inside of the project directory.

    heroku create NAME_OF_YOUR_APP

Once this returns successfully, push your app to Heroku.

    git push heroku master

### TIMEZONES

Heroku's servers have different timestamps than your time zone probably. To have Heroku use your
local time zone for timestamps on datamodels find your timezone on this chart:
http://en.wikipedia.org/wiki/List_of_tz_database_time_zones and then run the following in
Terminal:

    heroku config:add TZ="____YOURTIMEZONE____"
