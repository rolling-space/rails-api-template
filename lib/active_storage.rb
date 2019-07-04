# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ActiveStorage < Template::Writer
    def initialize(gems:)
      @gems = gems
    end

    def write
      return nil if @gems.active_storage?

      delete_active_storage!
    end

    private

    def delete_active_storage!
      delete_file('config/storage.yml')
    end
  end
end
