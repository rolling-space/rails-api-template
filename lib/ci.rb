# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')
require_relative('travis')
require_relative('circle')

module Template
  class CI < Template::Writer
    def initialize(ci:, gems:, db:, app_name:)
      @ci = ci.nil? ? false : "Template::#{ci.to_s.capitalize}".constantize.new(gems: gems, db: db, app_name: app_name)
    end

    def write
      return nil unless used?

      @ci.write
    end

    def used?
      @ci
    end
  end
end
