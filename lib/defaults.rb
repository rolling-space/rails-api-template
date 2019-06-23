# frozen_string_literal: true

module Template
  module Defaults
    OPTS = {
      prd: [
        'dotenv-rails',
        'dry-validation',
        'fast_jsonapi',
        'httparty',
        'rswag'
      ],
      dev: [
        'better_errors',
        'brakeman',
        'bundler-audit',
        'fasterer',
        'nested-generators',
        'pry-byebug',
        'rails_best_practices',
        'rubocop-rails'
      ],
      tst: [
        'database_cleaner',
        'coveralls',
        'factory_bot',
        'ffaker',
        'guard',
        'rails-controller-testing',
        'rspec-rails',
        'rubocop-rspec',
        'simplecov',
        'shoulda-matchers',
        'timecop',
      ],
      ci: [
        'CircleCI',
        'TravisCI',
        'Jenkins',
        'none'
      ],
      types: [
        'Default',
        'Custom'
      ]
    }
  end
end
