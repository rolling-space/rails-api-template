# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class DB < Template::Writer
    attr_reader :gems, :username, :password, :host, :name

    def initialize(provider:, app_name:, username:, password:, host: '127.0.0.1')
      @app_name = app_name
      @provider = provider
      @username = username
      @password = password
      @name = app_name.underscore
      @host = host
      @gems = {
        mysql: "gem 'mysql2', '>= 0.4.4'",
        pgsql: "gem 'pg', '>= 0.18', '< 2.0'",
        sqlite: "gem 'sqlite3', '~> 1.4'"
      }
    end

    def write
      return nil if sqlite?

      @config_database = Template::ConfigFile.new("config/database-#{@provider.to_s}.yml")
      @config_database.replace!('database: rat_dev_database', "  database: #{@name}_development")
      @config_database.replace!('database: rat_tst_database', "  database: #{@name}_test")
      @config_database.replace!('database: rat_prd_database', "  database: #{@name}_production")
      @config_database.write!('config/database.yml')
    end

    def pgsql?
      @provider == :pgsql
    end

    def mysql?
      @provider == :mysql
    end

    def sqlite?
      @provider == :sqlite
    end
  end
end
