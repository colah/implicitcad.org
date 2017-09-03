env = ENV['RAILS_ENV'] || 'development'
capitalized_env = "#{env[0].upcase}#{env[1..-1]}"
Dir.chdir(File.join(File.dirname(__FILE__), '..'))

puts "\n#{capitalized_env} Rails Server: Running Setup\n#{'-' * 50}"

`rm ./public/index.html`

if env == 'production'
  puts 'Precompiling..'
  `bundle exec rake assets:precompile`
  puts '[ DONE ]'
end

puts "\n#{capitalized_env} Rails Server: Running\n#{'-' * 50}"

exec 'unicorn -c ./config/unicorn.rb'
