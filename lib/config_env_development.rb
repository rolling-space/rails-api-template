# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ConfigEnvDevelopment < Template::Writer
    def initialize(gems:)
      @gems = gems
      @config_env_development = Template::ConfigFile.new('config/environments/development.rb')
    end

    def write
      delete_file('config/environments/development.rb')
      @config_env_development.drop!('rat-action-mailer') unless @gems.action_mailer?
      @config_env_development.drop!('rat-active-storage') unless @gems.active_storage?
      @config_env_development.cleanup('action-mailer', 'active-storage')
      @config_env_development.write!
    end
  end
end
