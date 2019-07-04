# frozen_string_literal: true

module Template
  class Gems
    def initialize(answers)
      @gems = answers.slice(:prd, :tst, :dev, :deploy).values.flatten
      @devtst = []
      @dev = []
      @tst = []
      @prd = []
    end

    attr_reader :prd, :dev, :tst, :devtst

    def organize!
      organize_devtst
      organize_dev
      organize_tst
      organize_prd
    end

    def better_errors?
      @better_errors ||= @gems.include?(:better_errors)
    end

    def brakeman?
      @brakeman ||= @gems.include?(:brakeman)
    end

    def bundler_audit?
      @bundler_audit ||= @gems.include?(:bundler_audit)
    end

    def capistrano?
      @capistrano ||= @gems.include?(:capistrano)
    end

    def coveralls?
      @coveralls ||= rspec? && @gems.include?(:coveralls)
    end

    def database_cleaner?
      @database_cleaner ||= rspec? && @gems.include?(:database_cleaner)
    end

    # TODO: dotenv + other options
    # def dotenv?
    #   @dotenv ||= @gems.include?(:dotenv)
    # end

    def dry_validation?
      @dry_validation ||= @gems.include?(:dry_validation)
    end

    def factory_bot?
      @factory_bot ||= rspec? && @gems.include?(:factory_bot)
    end

    def fast_jsonapi?
      @fast_jsonapi ||= @gems.include?(:fast_jsonapi)
    end

    def fasterer?
      @fasterer ||= @gems.include?(:fasterer)
    end

    def guard?
      @guard ||= rspec? && @gems.include?(:guard)
    end

    def httparty?
      @httparty ||= @gems.include?(:httparty)
    end

    def nested_generators?
      @nested_generators ||= @gems.include?(:nested_generators)
    end

    def pry_byebug?
      @pry_byebug ||= @gems.include?(:pry_byebug)
    end

    def rails_best_practices?
      @rails_best_practices ||= @gems.include?(:rails_best_practices)
    end

    # TODO: configure for Rails and add
    # def reek?
    #   @reek ||= @gems.include?(:reek)
    # end

    def rspec?
      @rspec ||= @gems.include?(:rspec)
    end

    def rubocop?
      @rubocop ||= @gems.include?(:rubocop)
    end

    def rswag?
      @rswag ||= @gems.include?(:rswag)
    end

    def shoulda_matchers?
      @shoulda_matchers ||= @gems.include?(:shoulda_matchers)
    end

    def simplecov?
      @simplecov ||= rspec? && @gems.include?(:simplecov)
    end

    def spring?
      @spring ||= @gems.include?(:spring)
    end

    def timecop?
      @timecop ||= rspec? && @gems.include?(:timecop)
    end

    private

    def organize_prd
      @prd << 'dotenv-rails'
      @prd << 'dry-validation' if dry_validation?
      @prd << 'fast_jsonapi' if fast_jsonapi?
      @prd << 'httparty' if httparty?
      @prd << 'redis'
      @prd << 'redis-rails'
      @prd << 'rswag-api' if rswag?
      @prd << 'rswag-ui' if rswag?
      @prd << 'sidekiq'
    end

    def organize_devtst
      @devtst << 'brakeman' if brakeman?
      @devtst << 'bundler-audit' if bundler_audit?
      @devtst << 'fasterer' if fasterer?
      @devtst << 'ffaker' if rspec?
      @devtst << 'nested-generators' if nested_generators?
      @devtst << 'pry-byebug' if pry_byebug?
      @devtst << 'rails_best_practices' if rails_best_practices?
      @devtst << 'rails-controller-testing' if rspec?
      # @devtst << 'reek' if reek?
      @devtst << 'rspec-rails' if rspec?

      if rubocop?
        @devtst << 'rubocop'
        @devtst << 'rubocop-performance'
        @devtst << 'rubocop-rails'
        @devtst << 'rubocop-rspec' if rspec?
      end
    end

    def organize_dev
      if better_errors?
        @dev << 'better_errors'
        @dev << 'binding_of_caller'
      end

      if capistrano?
        @dev << 'capistrano'
        @dev << 'capistrano-bundler'
        @dev << 'capistrano-rails'
        @dev << 'capistrano-rvm'
      end

      @dev << 'guard' if guard?
      @dev << 'spring' if spring?
    end

    def organize_tst
      if rspec?
        @tst << 'database_cleaner' if database_cleaner?
        @tst << 'coveralls' if coveralls?
        @tst << 'factory_bot_rails' if factory_bot?
        @tst << 'rspec-sidekiq'
        @tst << 'rswag-specs' if rswag?
        @tst << 'shoulda-matchers' if shoulda_matchers?
        @tst << 'simplecov' if simplecov?
        @tst << 'timecop' if timecop?
      end
    end
  end
end
