source 'https://rubygems.org'

# Bundle stable rails:
gem 'rails', git: 'https://github.com/rails/rails.git', branch: '3-2-stable'

# An earlier version of rake, to avoid the "no last comment" bug.
gem 'rake', '< 11.0'

# Database. not used, but required by activerecord?
# gem 'sqlite3', :group => [:development, :test]
# gem 'pg', :group => :production
gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.

group :assets, :production do
  # Asset Compilers
  gem 'coffee-rails', git: 'https://github.com/rails/coffee-rails.git', branch: '3-2-stable'
  gem 'haml-rails'
  gem 'iconv', '~> 1.0.3'
  gem 'sass'
  gem 'sass-rails', git: 'https://github.com/rails/sass-rails.git', tag: '3.2.2'
  gem 'therubyracer', platforms: :ruby # See https://github.com/sstephenson/execjs#readme for more supported runtimes

  # Asset Compressors
  gem 'uglifier', '>= 1.0.3'
  gem 'yui-compressor'

  # Railsified Assets
  gem 'bootstrap-sass', '~> 3.1.1'
  gem 'font-awesome-sass-rails'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
end

# Use unicorn as the app server
gem 'unicorn'

# For memcache
gem 'dalli'

# Authentication, and authorization.
gem 'authlogic'
gem 'bcrypt-ruby', '~> 3.0.0'

# not actively maintained. migrate to responders gem.
gem 'inherited_resources'

gem 'colored'
gem 'rest-client' # legacy, horrible performance over multiple requests
gem 'typhoeus', '0.5.0.pre' # way better performance over multiple requests
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap', git: 'https://github.com/f3ndot/will_paginate-bootstrap.git'

# Testing
group :production do
  gem "rspec-rails", "~> 2.0"
end


# to send email.
# gem 'actionmailer'
# gem 'rfc822'

# Other gems
# gem 'factory_girl_rails', '~> 3.0', :group => :development
# gem 'actionpack', '~> 3.0', :group => :development

# disabled, nothing broke?
# gem 'pry'
# gem 'god', :require => false
# gem 'json'
# gem 'fastercsv'
# gem 'rdiscount'

# Carrierwave allows file upload
# gem 'carrierwave'
# gem 'client_side_validations'
# gem 'carmen-rails', :git => 'https://github.com/lukast-akra/carmen-rails.git'
# gem 'responders'

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
