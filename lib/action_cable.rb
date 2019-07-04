# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ActionCable < Template::Writer
    def initialize(gems:)
      @gems = gems
    end

    def write
      return nil if @gems.action_cable?

      delete_action_cable!
    end

    private

    def delete_action_cable!
      delete_directory('app/channels')
    end
  end
end
