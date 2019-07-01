# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Sidekiq < Template::Writer
    
    attr_reader :used, :namespace

    def initialize(used:, namespace:, redis:)
      @used = used
      @namespace = namespace
      @redis = redis
    end

    def write
      return nil unless used?

      @config_initializers_sidekiq = Template::ConfigFile.new('config/sidekiq.yml')
      @config_initializers_sidekiq.drop!('rat-sentinel') unless @redis.sentinel?
      @config_initializers_sidekiq.cleanup('sentinel')
      @config_initializers_redis.write!
    end

    def used?
      @used
    end

    private

    def write_config_sidekiq!
      @config_sidekiq = Template::ConfigFile.new('config/initializers/sidekiq.rb')
      @config_sidekiq.replace!('namespace: sidekiq_dev', "namespace: #{@namespace}_dev")
      @config_sidekiq.replace!('namespace: sidekiq_prd', "namespace: #{@namespace}_prd")
      @config_sidekiq.replace!('namespace: sidekiq_tst', "namespace: #{@namespace}_tst")
      @config_sidekiq.write!
    end

    def write_config_initializers_sidekiq!
      @config_initializers_sidekiq = Template::ConfigFile.new('config/sidekiq.yml')
      @config_initializers_sidekiq.drop!('rat-sentinel') unless @redis.sentinel?
      @config_initializers_sidekiq.cleanup('sentinel')
      @config_initializers_sidekiq.write!
    end
  end
end
