# ImplicitCAD.org

## Installation

1. Install Ruby 1.9.3 and Ruby Gems
2. `gem install rails bundler unicorn`
3. `bundle update`
4. `bundle install`

## Running the Server

1. Set the rails environment to one of production, staging or development. For example: `export RAILS_ENV=production`.
2. `ruby ./script/unicorn_server.rb`

## Notes

ImplicitCAD.org uses r50 of webgl loader

## License

ImplicitCAD.org is released under the MIT license:

www.opensource.org/licenses/MIT
