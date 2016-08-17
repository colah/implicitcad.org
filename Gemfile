source 'https://rubygems.org'

#gem 'rails', '3.2.5'

# Bundle edge Rails instead:
gem 'rails', :git => 'https://github.com/rails/rails.git', :branch => "3-2-stable"

# Database
gem 'sqlite3', :group => :development
gem 'pg', :group => :production


# Gems used only for assets and not required
# in production environments by default.
#group :assets do

  # Asset Compilers

  gem 'sass'
  #gem 'sass-rails',   '~> 3.2.3'
  gem 'sass-rails', :git => "https://github.com/rails/sass-rails.git", :tag => "3.2.2"

  gem 'therubyracer', :platforms => :ruby # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #gem 'coffee-rails', '~> 3.2.1'
  gem 'coffee-rails', :git => "https://github.com/rails/coffee-rails.git", :branch => "3-2-stable"

#  gem 'sprockets-rails', :git => "https://github.com/rails/sprockets-rails.git", :tag => "v2.1.4"

#  gem 'sprockets', :git => "https://github.com/rails/sprockets.git", :tag => "v2.8.3"

  gem 'haml-rails'

gem "iconv", "~> 1.0.3"

  # Asset Compressors
  gem 'uglifier', '>= 1.0.3'
  #gem 'closure-compiler'
  gem 'yui-compressor'


  # Railsified Assets
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'font-awesome-sass-rails'
  gem 'bootstrap-sass', '~> 3.1.1'

#end


# Use unicorn as the app server
gem 'unicorn'

# For memcache
gem 'dalli'


# Auth, Permissions and Administration
gem 'authlogic'
#gem 'activeadmin', "~> 0.4.4"
gem 'bcrypt-ruby', '~> 3.0.0'


# Testing
group :test do
  gem 'sqlite3'
  gem "rspec-rails", "~> 2.0"
end


# Other Libraries
gem "actionmailer"
# Carrierwave allows file upload
# gem "carrierwave"
# gem 'client_side_validations'
# gem 'carmen-rails', :git => "https://github.com/lukast-akra/carmen-rails.git"
# gem 'responders'
gem 'inherited_resources'
gem 'factory_girl_rails', '~> 3.0', :group => :development
gem 'rfc822'
gem 'pry'
gem 'god', :require => false
gem 'json'
gem 'fastercsv'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap', :git => "https://github.com/f3ndot/will_paginate-bootstrap.git"
gem 'colored'
gem 'rdiscount'
gem 'rest-client' # legacy, horrible performance over multiple requests
gem 'typhoeus', "0.5.0.pre" # way better performance over multiple requests
gem 'newrelic_rpm'

# To use Jbuilder templates for JSON
# gem 'jbuilder'


# To deploy with Capistrano
# gem 'capistrano'


# To use debugger
# gem 'debugger'


# To perform cron jobs (pick one)
# gem 'resque'
# gem 'whenever'


# To enable geocoding (pick one: geocoder or geokit)
# gem 'geocoder'
# gem 'geokit'
# gem 'geokit-rails3'
