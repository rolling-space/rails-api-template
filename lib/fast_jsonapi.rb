# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class FastJSONAPI < Template::Writer
    def initialize(gems:)
      @gems = gems
    end

    def write
      return nil unless @gems.fast_jsonapi?

      delete_directory('app/serializers')
      create_directory('app/serializers')
      write_file('app/serializers/.keep', '')
    end
  end
end
