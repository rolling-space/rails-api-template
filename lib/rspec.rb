# frozen_string_literal: true

require_relative('writer')
require_relative('config_file')

module Template
  class RSpec < Template::Writer
    def initialize(gems:, sidekiq:)
      @gems = gems
      @sidekiq = sidekiq
      @spec_helper = Template::ConfigFile.new('spec/spec_helper.rb')
      @rails_helper = Template::ConfigFile.new('spec/rails_helper.rb')
      @dot_rspec = Template::ConfigFile.new('.rspec')
    end

    def write
      delete_directory('test')
      delete_directory('spec')
      create_directory('spec')
      write_dot_rspec!
      write_rails_helper!
      write_spec_helper!
    end

    private

    def write_dot_rspec!
      @dot_rspec.write!
    end

    def write_rails_helper!
      @rails_helper.drop!('rat-shoulda-matchers') unless @gems.shoulda_matchers?
      @rails_helper.drop!('rat-database-cleaner') unless @gems.database_cleaner?
      @rails_helper.drop!('rat-factory-bot') unless @gems.factory_bot?
      @rails_helper.drop!('rat-sidekiq') unless @sidekiq.used?
      @rails_helper.cleanup('shoulda-matchers', 'database-cleaner', 'factory-bot', 'sidekiq')
      @rails_helper.write!
    end

    def write_spec_helper!
      @spec_helper.drop!('rat-coveralls') unless @gems.coveralls?
      @spec_helper.drop!('rat-simplecov') unless @gems.simplecov?
      @spec_helper.cleanup('simplecov', 'coveralls')
      @spec_helper.write!
    end
  end
end
