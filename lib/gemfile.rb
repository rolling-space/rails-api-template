# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Gemfile < Template::Writer
    def initialize(gems:, db:, redis:, sidekiq:)
      @gems = gems
      @db = db
      @redis = redis
      @sidekiq = sidekiq
      @gemfile = Template::ConfigFile.new('Gemfile')
    end

    def write
      ruby_version!
      rails_version!
      db!
      prd_gems!
      dev_tst_gems!
      dev_gems!
      tst_gems!
      @gemfile.write!
    end

    private

    def ruby_version!
      @gemfile.replace!('ruby \'2.', "ruby '#{RUBY_VERSION}'")
    end

    def rails_version!
      @gemfile.replace!("gem 'rails'", "gem 'rails', '~> #{Rails::VERSION::STRING}'")
    end

    def db!
      @gemfile.drop!(@db.gems[:pgsql], @db.gems[:sqlite]) if @db.mysql?
      @gemfile.drop!(@db.gems[:mysql], @db.gems[:sqlite]) if @db.pgsql?
      @gemfile.drop!(@db.gems[:pgsql], @db.gems[:mysql]) if @db.sqlite?
    end

    def prd_gems!
      # TODO: dotenv + other options
      # @gemfile.drop!('dotenv') unless @gems.dotenv?
      @gemfile.drop!('dry-validation') unless @gems.dry_validation?
      @gemfile.drop!('fast_jsonapi') unless @gems.fast_jsonapi?
      @gemfile.drop!('httparty') unless @gems.httparty?
      @gemfile.drop!('redis') unless @redis.used?
      @gemfile.drop!('rswag') unless @gems.rswag?
      @gemfile.drop!('sidekiq') unless @sidekiq.used?
    end

    def dev_tst_gems!
      @gemfile.drop!("gem 'byebug'") if @gems.pry_byebug?
      @gemfile.drop!('brakeman') unless @gems.brakeman?
      @gemfile.drop!('bundler-audit') unless @gems.bundler_audit?
      @gemfile.drop!('fasterer') unless @gems.fasterer?
      @gemfile.drop!('nested-generators') unless @gems.nested_generators?
      @gemfile.drop!('pry-byebug') unless @gems.pry_byebug?
      @gemfile.drop!('rails_best_practices') unless @gems.rails_best_practices?
      @gemfile.drop!('rails_controller_testing') unless @gems.rspec?
      @gemfile.drop!('rspec') unless @gems.rspec?
      @gemfile.drop!('rubocop') unless @gems.rubocop?
      @gemfile.drop!('spring') unless @gems.spring?
    end

    def dev_gems!
      @gemfile.drop!('better_errors', 'binding_of_caller') unless @gems.better_errors?
      @gemfile.drop!('capistrano') unless @gems.capistrano?
      @gemfile.drop!('guard') unless @gems.guard?
    end

    def tst_gems!
      @gemfile.drop!('database_cleaner') unless @gems.database_cleaner?
      @gemfile.drop!('coveralls') unless @gems.coveralls?
      @gemfile.drop!('factory_bot_rails') unless @gems.factory_bot?
      @gemfile.drop!('simplecov') unless @gems.simplecov?
      @gemfile.drop!('shoulda-matchers') unless @gems.shoulda_matchers?
      @gemfile.drop!('timecop') unless @gems.timecop?
    end
  end
end
