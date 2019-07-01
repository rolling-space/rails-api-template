# frozen_string_literal: true

require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)
Dotenv::Railtie.load # rat-dotenv

module RATAppName
  class Application < Rails::Application
    config.api_only = true
    config.load_defaults 6.0
    config.generators do |generator| # rat-rspec
      generator.test_framework :rspec, fixtures: true, # rat-rspec
                                       controller_specs: true, # rat-rspec
                                       routing_specs: true, # rat-rspec
                                       request_specs: true # rat-rspec
      generator.fixture_replacement :factory_bot, dir: 'spec/factories' # rat-factory-bot
    end
  end
end
