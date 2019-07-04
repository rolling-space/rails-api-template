# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ConfigEnvTest < Template::Writer
    def initialize(gems:)
      @gems = gems
      @config_env_test = Template::ConfigFile.new('config/environments/test.rb')
    end

    def write
      delete_file('config/environments/test.rb')
      @config_env_test.drop!('rat-action-mailer') unless @gems.action_mailer?
      @config_env_test.drop!('rat-active-storage') unless @gems.active_storage?
      @config_env_test.cleanup('action-mailer', 'active-storage')
      @config_env_test.write!
    end
  end
end
