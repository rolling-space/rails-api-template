# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Shoulda::Matchers.configure do |config| # rat-shoulda-matchers
  config.integrate do |with| # rat-shoulda-matchers
    with.test_framework :rspec # rat-shoulda-matchers
    with.library :rails # rat-shoulda-matchers
  end # rat-shoulda-matchers
end # rat-shoulda-matchers

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
 # rat-database-cleaner
  config.before(:suite) do # rat-database-cleaner
    DatabaseCleaner.strategy = :truncation # rat-database-cleaner
    DatabaseCleaner.clean_with(:truncation) # rat-database-cleaner
  end # rat-database-cleaner
 # rat-database-cleaner
  config.before do # rat-database-cleaner
    DatabaseCleaner.strategy = :transaction # rat-database-cleaner
    DatabaseCleaner.start # rat-database-cleaner
  end # rat-database-cleaner
 # rat-database-cleaner
  config.append_after do # rat-database-cleaner
    DatabaseCleaner.clean # rat-database-cleaner
  end # rat-database-cleaner
 # rat-factory-bot
  config.include FactoryBot::Syntax::Methods # rat-factory-bot
end
 # rat-sidekiq
RSpec::Sidekiq.configure do |config| # rat-sidekiq
  config.warn_when_jobs_not_processed_by_sidekiq = false # rat-database-cleaner
end # rat-database-cleaner
