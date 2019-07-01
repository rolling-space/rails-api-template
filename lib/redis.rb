# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Redis < Template::Writer
    attr_reader :redis_url, :redis_db, :redis_port, :sentinel_url, :sentinel_db, :sentinel_port, :sentinel_hosts

    def initialize(used:, redis_url:, redis_db:, redis_port:, sentinel_used:, sentinel_url:, sentinel_db:, sentinel_port:, sentinel_hosts:)
      @used = used
      @redis_url = redis_url
      @redis_db = redis_db
      @redis_port = redis_port
      @sentinel_used = sentinel_used
      @sentinel_url = sentinel_url
      @sentinel_db = sentinel_db
      @sentinel_port = sentinel_port
      @sentinel_hosts = sentinel_hosts
    end

    def write
      return nil unless used?

      @config_initializers_redis = Template::ConfigFile.new('config/initializers/redis.rb')
      @config_initializers_redis.drop!('rat-sentinel') unless sentinel?
      @config_initializers_redis.cleanup('sentinel')
      @config_initializers_redis.write!
    end

    def used?
      @used
    end

    def sentinel?
      @sentinel_used
    end
  end
end
