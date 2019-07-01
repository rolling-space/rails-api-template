# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Travis < Template::Writer
    def initialize(gems:, db:)
      @gems = gems
      @db = db
    end

    def write
      @dot_travis = Template::ConfigFile.new('.travis.yml')
      if @db.mysql?
        @dot_travis.drop!('rat-pgsql')
        @dot_travis.cleanup('mysql')
        @dot_travis.gsub!()
        @dot_travis.gsub!('MYSQL_ROOT_PASSWORD:', "MYSQL_ROOT_PASSWORD: #{@db.password}")
        @dot_travis.gsub!('MYSQL_DATABASE:', "MYSQL_DATABASE: #{@db.name}")
        @dot_travis.gsub!('MYSQL_USER:', "MYSQL_USER: #{@db.username}")
        @dot_travis.gsub!('MYSQL_PASSWORD:', "MYSQL_PASSWORD: #{@db.password}")
      elsif @db.pgsql?
        @dot_travis.drop!('rat-mysql')
        @dot_travis.gsub!('DB_HOST:', "DB_HOST: #{@db.host}")
        @dot_travis.gsub!('DB_USERNAME:', "DB_USERNAME: #{@db.username}")
        @dot_travis.gsub!('DB_PASSWORD:', "DB_PASSWORD: #{@db.passowrd}")
        @dot_travis.gsub!('POSTGRES_USER:', "POSTGRES_USER: #{@db.username}")
        @dot_travis.gsub!('POSTGRES_DB:', "POSTGRES_DB: #{@db.name}")
      end

      @dot_travis.drop!('rat-brakeman') unless @gems.brakeman?
      @dot_travis.drop!('rat-bundle-audit') unless @gems.bundle_audit?
      @dot_travis.drop!('rat-fasterer') unless @gems.fasterer?
      @dot_travis.drop!('rat-rspec') unless @gems.rspec?
      @dot_travis.drop!('rat-rubocop') unless @gems.rubocop?
      @dot_travis.drop!('rat-simplecov') unless @gems.simplecov?
      @dot_travis.cleanup('brakeman', 'bundle-audit', 'fasterer', 'rspec', 'rubocop', 'simplecov')
      @dot_travis.write!
    end
  end
end
