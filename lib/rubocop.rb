# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class RuboCop < Template::Writer
    def initialize(gems:)
      @gems = gems
      @dot_rubocop = Template::ConfigFile.new('.rubocop.yml')
    end

    def write
      return nil unless @gems.rubocop?

      delete_file('.rubocop.yml')
      write_dot_rubocop!
    end

    private

    def write_dot_rubocop!
      @dot_rubocop.drop!('rat-rspec') unless @gems.rspec?
      @dot_rubocop.cleanup('rspec')
      @dot_rubocop.write!
    end
  end
end
