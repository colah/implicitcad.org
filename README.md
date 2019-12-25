# ImplicitCAD.org

## Installation

### Debian
1. Install required debs:
  * `apt install ruby2.3 ruby2.3-dev libpq-dev libsqlite3-dev ruby-bundler g++ make`
2. Install ruby dependancies (In the source dir):
  * `bundle update && bundle install`

### Other
1. Install Ruby 1.9.3 and Ruby Gems
2. `gem install bundler`
3. `bundle update`
4. `bundle install`

## Running the Server

1. Set the rails environment to one of production, staging or development. For example: `export RAILS_ENV=production`.
2. `bundle exec ./script/unicorn_server.rb`

This opens the server on port 9001, by default. It is reccomended that you use apache to forwart traffic to this host.

## Notes

For versions of dependent components, please see vendor/sources .

## License

ImplicitCAD.org is now licensed under the GNU AGPL version 3 or greater.
see the LICENSE file for more details.

ImplicitCAD.org was originally released under the MIT license:

www.opensource.org/licenses/MIT
