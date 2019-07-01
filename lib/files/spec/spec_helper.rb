# frozen_string_literal: true

require 'coveralls' # rat-coveralls
require 'simplecov' # rat-simplecov

Dir['./spec/shared_examples/**/*.rb'].sort.each { |shared_example| require shared_example }

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter, # rat-coveralls
                                                                Coveralls::SimpleCov::Formatter]) # rat-coveralls
SimpleCov.start # rat-simplecov

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.profile_examples = 5
  config.order = :defined
end
