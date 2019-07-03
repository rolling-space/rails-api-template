# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class DryValidation < Template::Writer
    def initialize(gems:)
      @gems = gems
    end

    def write
      return nil unless @gems.dry_validation?

      create_directory('app/dry_validation/contracts')
      create_directory('app/dry_validation/schemas')
      write_file('app/dry_validation/contracts/.keep')
      write_file('app/dry_validation/schemas/.keep')
    end
  end
end
