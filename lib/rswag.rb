# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Rswag < Template::Writer
    def initialize(gems:)
      @gems = gems
      @config_initializers_rswag_api = Template::ConfigFile.new('config/initializers/rswag_api.rb')
      @config_routes = Template::ConfigFile.new('config/routes.rb')
    end

    def write
      write_config_routes!
      return nil unless @gems.rswag?

      delete_file('config/initializers/rswag_api.rb')
      write_config_initializers_rswag_api!
    end

    private

    def write_config_initializers_rswag_api!
      @config_routes.drop!('rat-rswag') unless @gems.rswag?
      @config_routes.cleanup('rat-rswag')
      @config_routes.write!
    end

    def write_config_initializers_rswag_api!
      @config_initializers_rswag_api.write!
    end
  end
end
