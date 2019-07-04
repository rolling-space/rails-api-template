# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')
require_relative('travis')
require_relative('circle')

module Template
  class ConfigApplication < Template::Writer
    def initialize(gems:, app_name:)
      @gems = gems
      @app_name = app_name
      @config_application = Template::ConfigFile.new('config/application.rb')
    end

    def write
      delete_file('config/application.rb')
      @config_application.drop!('rat-action-cable') unless @gems.action_cable?
      @config_application.drop!('rat-action-mailer') unless @gems.action_mailer?
      @config_application.drop!('rat-active-job') unless @gems.active_job?
      @config_application.drop!('rat-active-storage') unless @gems.active_storage?
      @config_application.drop!('rat-rspec') unless @gems.rspec?
      @config_application.drop!('rat-factory-bot') unless @gems.rspec? && @gems.factory_bot?
      @config_application.replace!('module RATAppName', "module #{@app_name}")
      @config_application.cleanup('action-cable', 'action-mailer', 'active-job', 'active-storage', 'dotenv', 'rspec', 'factory-bot')
      @config_application.write!
    end
  end
end
