# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class DotEnv < Template::Writer
    def initialize(gems:, db:, redis:)
      @gems = gems
      @db = db
      @redis = redis
      @dot_env = Template::ConfigFile.new('.env')
    end

    def write
      # TODO: dotenv + other options
      # return nil unless @gems.dotenv?

      delete_file('.env')
      write_dot_env!
    end

    private

    def write_dot_env!
      if @redis.used?
        @dot_env.replace!('REDIS_DB=', "REDIS_DB=#{@redis.redis_db}")
        @dot_env.replace!('REDIS_URL=', "REDIS_URL=#{@redis.redis_url}")
        @dot_env.replace!('REDIS_PORT=', "REDIS_PORT=#{@redis.redis_port}")
        if @redis.sentinel?
          @dot_env.replace!('SENTINEL_URL=', "SENTINEL_URL=#{@redis.sentinel_url}/#{@redis.sentinel_db}")
          @dot_env.replace!('SENTINEL_PORT=', "SENTINEL_PORT=#{@redis.sentinel_port}")
          @dot_env.replace!('SENTINEL_HOSTS=', "SENTINEL_HOSTS=#{@redis.sentinel_hosts}")
        else
          @dot_env.drop!('SENTINEL')
        end
      else
        @dot_env.drop!('REDIS')
      end
      @dot_env.write!('.env.sample')
      @dot_env.replace!('DB_USERNAME=', "DB_USERNAME=#{@db.username}") unless @db.sqlite?
      @dot_env.replace!('DB_PASSWORD=', "DB_PASSWORD=#{@db.password}") unless @db.sqlite?
      @dot_env.replace!('DB_HOST=', "DB_HOST=#{@db.host}") unless @db.sqlite?
      @dot_env.write!
    end
  end
end
