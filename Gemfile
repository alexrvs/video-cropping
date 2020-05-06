source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Db
# Wrapper MongoDb
gem 'mongoid'
gem 'kaminari-mongoid', '~> 0.1.0'

# Uploaders
gem 'carrierwave-video'
gem 'carrierwave_backgrounder', github: 'lardawge/carrierwave_backgrounder'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'

# Background Jobs
gem 'sidekiq'

# Ffmpeg wprapper
gem 'streamio-ffmpeg'

# Api instruments
gem 'active_model_serializers', '~> 0.10.0'
gem 'versionist'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.6'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
end

gem 'aasm', '~> 4.11', '>= 4.11.1'


group :test do
  gem 'mongoid-rspec'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'rswag'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
