# A sample Gemfile
source 'https://rubygems.org'

# Bundle from GitHub, as only a prerelease is currently available.
gem 'crepe', github: 'crepe/crepe'
gem 'creperie', github: 'crepe/creperie'
gem 'app'

gem 'docker-api'
gem 'octokit', '~> 3.0'

# Use Jsonite to convert objects to JSON for presentation. Place
# presenters in the app/presenters/ directory.
#
# More info: https://github.com/barrelage/jsonite
# gem 'jsonite', github: 'barrelage/jsonite'

# Use puma as the web server.
gem 'puma'

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
end
