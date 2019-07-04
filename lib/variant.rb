# frozen_string_literal: true

module Template
  class Variant
    include Template::Defaults

    attr_reader :options

    def initialize(answers)
      @db_provider = answers[:db_provider]
      @db_username = answers[:db_username]
      @db_password = answers[:db_password]
      @db_host = answers[:db_host]
      @redis = answers[:redis]
      @redis_url = answers[:redis_url]
      @redis_db = answers[:redis_db]
      @redis_port = answers[:redis_port]
      @sentinel = answers[:sentinel]
      @sentinel_url = answers[:sentinel_url]
      @sentinel_db = answers[:sentinel_db]
      @sentinel_port = answers[:sentinel_port]
      @sentinel_hosts = answers[:sentinel_hosts]
      @sidekiq = answers[:sidekiq]
      @git = answers[:git]
      @git_remote = answers[:git_remote]
      @git_credentials = answers[:git_credentials]
      @git_username = answers[:git_username]
      @git_email = answers[:git_email]
      @git_branching_model = answers[:git_branching_model]
      @ci = answers[:ci]
      @options = answers[:type] == :custom ? answers : predefined
    end

    private

    def predefined
      case @type
      when :default then default
      # TODO: other predefined schemas
      else default
      end
    end

    def default
      {}.tap do |h|
        h[:prd] = OPTS[:prd].map { |opt| opt[:value] }
        h[:prd] << :dotenv
        h[:dev] = OPTS[:dev].map { |opt| opt[:value] }.select { |opt| opt != :spring }
        h[:tst] = OPTS[:tst].map { |opt| opt[:value] }
        h[:ci] = OPTS[:ci].map { |opt| opt[:value] }
        h[:db_provider] = @db_provider
        h[:db_username] = @db_username
        h[:db_password] = @db_password
        h[:db_host] = @db_host
        h[:redis] = @redis
        h[:redis_url] = @redis_url
        h[:redis_db] = @redis_db
        h[:redis_port] = @redis_port
        h[:sentinel] = @sentinel
        h[:sentinel_url] = @sentinel_url
        h[:sentinel_db] = @sentinel_db
        h[:sentinel_port] = @sentinel_port
        h[:sentinel_hosts] = @sentinel_hosts
        h[:sidekiq] = @sidekiq
        h[:ci] = :circle
        h[:git] = @git
        h[:git_remote] = @git_remote
        h[:git_credentials] = @git_credentials
        h[:git_username] = @git_username
        h[:git_email] = @git_email
        h[:git_branching_model] = @git_branching_model
      end
    end
  end
end
