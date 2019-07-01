begin
  require 'tty-prompt'
rescue LoadError
  puts 'This template requires tty-prompt. Run `gem install tty-prompt` before using it'
end

# Template wizzard helpers
## Web server
# - puma
# - thin
# - unicorn
# - phusion passenger (apache/nginx)
# - phusion passenger (standalone)
## Tests
# - All (default)
# - database_cleaner
# - coveralls
# - factory_bot
# - ffaker
# - rspec-rails
# - rubocop-rspec
# - simplecov
# - shoulda-matchers
# - timecop
# - guard
## Development
# - All (default)
# - brakeman
# - bundler-audit
# - rubocop (rubocop-rails)
# - pry-byebug
# - fasterer
# - rails_best_practices
# - rails-controller-testing
# - better_errors
# - nested-generators
## Production
# - All (default)
# - dotenv-rails
# - dry-validation
# - fast_jsonapi
# - httparty
# - rswag
# - sidekiq
## Deploy?
# - Capistrano (default)
# - none
## Continous Integration
# - CircleCI (default)
# - none








# gem 'dotenv-rails'
# gem 'dry-validation'

# gem_group :development do
#   gem 'capistrano'
#   gem 'capistrano-bundler'
#   gem 'capistrano-rails'
#   gem 'capistrano-rvm'
#   gem 'overcommit'
#   gem 'rspec-rails'
#   gem 'rubocop'
# end

# gem_group :test do
#   gem 'database_cleaner'
#   gem 'factory_bot_rails'
#   gem 'fuubar'
#   gem 'simplecov'
# end

# gem_group :development, :test do
#   gem 'brakeman'
#   gem 'bundler-audit'
#   gem 'fasterer'
#   gem 'ffaker'
#   gem 'pry-byebug'
#   gem 'rails_best_practices'
#   gem 'rails-controller-testing'
#   gem 'reek'
#   gem 'rspec-rails'
#   gem 'rubocop-rspec'
# end

# environment %{config.generators do |generator|
#   generator.test_framework :rspec,
#                            fixtures: true,
#                            controller_specs: true,
#                            routing_specs: false,
#                            request_specs: false
#   generator.fixture_replacement :factory_bot, dir: 'spec/factories'
# end}

# file '.circleci/config.yml', <<-CODE

# CODE

# after_bundle do
#   run 'echo ".env" >> .gitignore'
#   run 'echo "config/database.yml" >> .gitignore'
#   run 'echo ".rspec" >> .gitignore'
#   run 'echo "coverage" >> .gitignore'
#   run 'touch lib/tasks/.keep'
#   run 'cp config/database.yml config/database.yml.sample'
#   run 'touch .env'
#   run 'cp .env .env.sample'
#   run 'rails generate rspec:install'
#   run 'cp .rspec.sample .rspec'
#   run 'sed -i "1irequire \'simplecov\'\nSimpleCov.start\n\n" spec/spec_helper.rb'
#   run 'sed -i "/^[[:blank:]]*#/d;s/#.*//" config/application.rb'
#   run 'sed -i "/^[[:blank:]]*#/d;s/#.*//" config/environment.rb'
#   run 'rubocop --safe-auto-correct'
#   git :init
#   git_user_name = ask('Your git user name')
#   run "git config user.name #{git_user_name}"
#   git_user_email = ask('Your git user email')
#   run "git config user.email #{git_user_email}"
#   git add: '.'
#   git commit: "-a -m 'Initial commit'"
#   git_repository_origin = ask('Your git repository origin HTTP or SSH address')
#   run "git remote add origin #{git_repository_origin}"
#   run 'git hf init'
#   run 'overcommit -i'
# end
