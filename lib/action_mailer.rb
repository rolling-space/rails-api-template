# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class ActionMailer < Template::Writer
    def initialize(gems:)
      @gems = gems
    end

    def write
      return nil if @gems.action_mailer?

      delete_action_mailer!
    end

    private

    def delete_action_mailer!
      delete_directory('app/mailers')
      delete_directory('app/views')
    end
  end
end
