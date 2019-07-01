# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Circle < Template::Writer
    JOBS = %w[brakeman bundle-audit fasterer rspec rubocop simplecov rails-best-practices]

    def initialize(gems:, db:, app_name:)
      @app_name = app_name
      @gems = gems
      @db = db
    end

    def write
      delete_directory('.circleci')
      @dot_circleci_config = Template::ConfigFile.new('.circleci/config.yml')
      @dot_circleci_config.drop!('rat-pgsql') unless @db.pgsql?
      @dot_circleci_config.drop!('rat-mysql') unless @db.mysql?
      @dot_circleci_config.drop!('rat-sqlite') unless @db.sqlite?

      if @db.mysql?
        @dot_circleci_config.cleanup('mysql')
        @dot_circleci_config.gsub!('MYSQL_DATABASE:', "MYSQL_DATABASE: #{@db.name}_test")
        @dot_circleci_config.gsub!('MYSQL_USER:', "MYSQL_USER: #{@db.username}")
        @dot_circleci_config.gsub!('MYSQL_PASSWORD:', "MYSQL_PASSWORD: #{@db.password}")
      elsif @db.pgsql?
        @dot_circleci_config.gsub!('PGHOST:', "PGHOST: #{@db.host}")
        @dot_circleci_config.gsub!('PGUSER:', "PGUSER: #{@db.username}")
        @dot_circleci_config.gsub!('POSTGRES_USER:', "POSTGRES_USER: #{@db.username}")
        @dot_circleci_config.gsub!('POSTGRES_DB:', "POSTGRES_DB: #{@db.name}_test")
      end

      @dot_circleci_config.drop!('rat-brakeman') unless @gems.brakeman?
      @dot_circleci_config.drop!('rat-bundle-audit') unless @gems.bundler_audit?
      @dot_circleci_config.drop!('rat-fasterer') unless @gems.fasterer?
      @dot_circleci_config.drop!('rat-rails_best_practices') unless @gems.rails_best_practices?
      @dot_circleci_config.drop!('rat-rspec') unless @gems.rspec?
      @dot_circleci_config.drop!('rat-rubocop') unless @gems.rubocop?
      @dot_circleci_config.gsub!('rat-app-name', @app_name.underscore)
      @dot_circleci_config.cleanup(*JOBS)
      create_directory('.circleci')
      @dot_circleci_config.write!
    end
  end
end
