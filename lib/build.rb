# frozen_string_literal: true

require_relative('capistrano.rb')
require_relative('ci.rb')
require_relative('db.rb')
require_relative('dotenv.rb')
require_relative('dry_validation.rb')
require_relative('fast_jsonapi.rb')
require_relative('fasterer.rb')
require_relative('gemfile.rb')
require_relative('redis.rb')
require_relative('rspec.rb')
require_relative('rswag.rb')
require_relative('rubocop.rb')
require_relative('sidekiq.rb')

module Template
  class Build
    attr_reader :gems

    def initialize(app_name:, answers:)
      @app_name = app_name
      @gems = Template::Gems.new(answers)
      @db = Template::DB.new(provider: answers[:db_provider],
                             username: answers[:db_username],
                             password: answers[:db_password],
                             host: answers[:db_host],
                             app_name: app_name)
      @redis = Template::Redis.new(used: answers[:redis],
                                   redis_url: answers[:redis_url],
                                   redis_db: answers[:redis_db],
                                   redis_port: answers[:redis_port],
                                   sentinel_used: answers[:sentinel],
                                   sentinel_url: answers[:sentinel_url],
                                   sentinel_db: answers[:sentinel_db],
                                   sentinel_port: answers[:sentinel_port],
                                   sentinel_hosts: answers[:sentinel_hosts])
      @sidekiq = Template::Sidekiq.new(used: answers[:sidekiq],
                                       namespace: answers[:sidekiq_namespace],
                                       redis: @redis)
      @gemfile = Template::Gemfile.new(gems: @gems, db: @db, redis: @redis, sidekiq: @sidekiq)
      @rspec = Template::RSpec.new(gems: @gems, app_name: @app_name, sidekiq: @sidekiq)
      @rubocop = Template::RuboCop.new(gems: @gems)
      @rswag = Template::Rswag.new(gems: @gems)
      @dotenv = Template::DotEnv.new(gems: @gems, db: @db, redis: @redis)
      @fast_jsonapi = Template::FastJsonApi.new(gems: @gems)
      @fasterer = Template::Fasterer.new(gems: @gems)
      @dry_validation = Template::DryValidation.new(gems: @gems)
      @ci = Template::CI.new(ci: answers[:ci], gems: @gems, db: @db, app_name: @app_name)
    end

    def call
      @gems.organize!
      @gemfile.write
      @db.write
      @rspec.write
      @rubocop.write
      @rswag.write
      @dotenv.write
      @redis.write
      @fast_jsonapi.write
      @dry_validation.write
      @fasterer.write
      @ci.write
    end
  end
end
