# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class Fasterer < Template::Writer
    def initialize(gems:)
      @gems = gems
      @dot_fasterer = Template::ConfigFile.new('.fasterer.yml')
    end

    def write
      return nil unless @gems.fasterer?

      delete_file('.fasterer.yml')
      write_dot_fasterer!
    end

    private

    def write_dot_fasterer!
      @dot_fasterer.write!
    end
  end
end
