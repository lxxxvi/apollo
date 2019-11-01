source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'haml-rails'
gem 'jbuilder'
gem 'mosaiq'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
gem 'pg'
gem 'puma'
gem 'pundit'
gem 'rails', '~> 6.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem 'simple_form'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end
