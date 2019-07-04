# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ConfigEnvProduction < Template::Writer
    def initialize(gems:)
      @gems = gems
      @config_env_production = Template::ConfigFile.new('config/environments/production.rb')
    end

    def write
      delete_file('config/environments/production.rb')
      @config_env_production.drop!('rat-action-mailer') unless @gems.action_mailer?
      @config_env_production.drop!('rat-active-storage') unless @gems.active_storage?
      @config_env_production.cleanup('action-mailer', 'active-storage')
      @config_env_production.write!
    end
  end
end
