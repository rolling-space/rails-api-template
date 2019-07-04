# frozen_string_literal: true

module Template
  module Defaults
    OPTS = {
      types: [
        {
          name: 'Default',
          value: :default
        },
        {
          name: 'Custom',
          value: :custom
        }
      ],
      prd: [
        { name: 'ActionCable', value: :action_cable },
        { name: 'ActionMailer', value: :action_mailer },
        { name: 'ActiveJob', value: :active_job },
        { name: 'ActiveStorage', value: :active_storage },
        { name: 'Capistrano', value: :capistrano },
        # TODO: dotenv + other options
        # { name: 'Dotenv', value: :dotenv },
        { name: 'DRY Validation', value: :dry_validation },
        { name: 'Fast JSON API (Netflix)', value: :fast_jsonapi },
        { name: 'HTTParty', value: :httparty },
        { name: 'RSWAG', value: :rswag }
      ],
      dev: [
        { name: 'Better Errors', value: :better_errors },
        { name: 'Brakeman', value: :brakeman },
        { name: 'Bundler Audit', value: :bundler_audit },
        { name: 'Fasterer (Fastruby)', value: :fasterer },
        { name: 'Nested Generators', value: :nested_generators },
        { name: 'binding.pry', value: :pry_byebug },
        { name: 'Rails Best Practices', value: :rails_best_practices },
        { name: 'RuboCop', value: :rubocop },
        { name: 'Spring', value: :spring }
      ],
      tst: [
        { name: 'Database Cleaner', value: :database_cleaner },
        { name: 'Coveralls', value: :coveralls },
        { name: 'Factory Bot', value: :factory_bot },
        { name: 'FFaker', value: :ffaker },
        { name: 'Guard', value: :guard },
        { name: 'Rails Controller Testing', value: :rails_controller_testing },
        { name: 'RSpec', value: :rspec },
        { name: 'SimpleCov', value: :simplecov },
        { name: 'Shoulda Matchers', value: :shoulda_matchers },
        { name: 'TimeCop', value: :timecop }
      ],
      ci: [
        { name: 'CircleCI', value: :circle },
        # TODO:
        # { name: 'TravisCI', value: :travis },
        # { name: 'Jenkins', value: :jenkins },
        { name: 'None', value: nil }
      ],
      db_provider: [
        { name: 'MySQL', value: :mysql },
        { name: 'PostgreSQL', value: :pgsql },
        { name: 'SQLite', value: :sqlite }
      ],
      db_username: '',
      db_password: '',
      db_host: '',
      redis: true,
      redis_url: 'redis://127.0.0.1',
      redis_db: '0',
      redis_port: '6379',
      sentinel: false,
      sentinel_url: 'redis://sentinel-master',
      sentinel_db: '0',
      sentinel_port: '26379',
      sentinel_hosts: 'sentinel-slave-1 sentinel-slave-2 sentinel-slave-3',
      sidekiq: true,
      git: true,
      git_remote: '',
      git_credentials: false,
      git_username: ENV['USER'],
      git_email: '',
      git_branching_model: [
        { name: 'hubflow', value: :hubflow },
        { name: 'gitflow', value: :gitflow },
        { name: 'none', value: :none }
      ],
    }
  end
end
