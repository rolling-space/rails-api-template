# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ActiveJob < Template::Writer
    def initialize(gems:)
      @gems = gems
    end

    def write
      return nil if @gems.active_job?

      delete_active_job!
    end

    private

    def delete_active_job!
      delete_directory('app/jobs')
    end
  end
end
