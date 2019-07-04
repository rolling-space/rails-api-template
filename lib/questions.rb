# frozen_string_literal: true

require 'tty-prompt'

module Template
  class Questions
    include Template::Defaults
    include Template::RailsNewFlags

    attr_reader :answers

    def initialize(active_color: :bright_yellow, flags:)
      @active_color = active_color
      @flags = flags
      @answers = {}.tap do |h|
        h[:db_provider] = db_provider_flag if db_flag?
        h[:git] = false if no_git?
      end
    end

    def type
      @answers[:type] ||= TTY::Prompt.new.select(
        'Installation type',
        OPTS[:types],
        echo: false,
        cycle: true,
        per_page: OPTS[:types].length,
        active_color: @active_color
      )
    end

    def prd
      @answers[:prd] ||= TTY::Prompt.new.multi_select(
        'Production gems',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        menu.help('all by default')
        menu.default(*prd_defaults)
        menu.per_page(OPTS[:prd].length)
        OPTS[:prd].each { |opt| menu.choice(opt) }
      end
    end

    def dev
      @answers[:dev] ||= TTY::Prompt.new.multi_select(
        'Development gems',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        menu.help('all but Spring by default')
        menu.default(*dev_defaults) # all except spring
        menu.per_page(OPTS[:dev].length)
        OPTS[:dev].each { |opt| menu.choice(opt) }
      end
    end

    def tst
      @answers[:tst] ||= TTY::Prompt.new.multi_select(
        'Test gems',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        menu.help('all by default')
        menu.default(*(1..OPTS[:tst].length).to_a)
        menu.per_page(OPTS[:tst].length)
        OPTS[:tst].each { |opt| menu.choice(opt) }
      end
    end

    def ci
      @answers[:ci] ||= TTY::Prompt.new.select(
        'Continous Integration',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        menu.help('all by default')
        menu.default(1)
        menu.per_page(OPTS[:ci].length)
        OPTS[:ci].each { |opt| menu.choice(opt) }
      end
    end

    def db_provider
      @answers[:db_provider] ||= TTY::Prompt.new.select(
        'Database',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        # menu.help('all by default')
        menu.default(1)
        menu.per_page(OPTS[:db_provider].length)
        OPTS[:db_provider].each { |opt| menu.choice(opt) }
      end
    end

    def db_username
      @answers[:db_username] ||= TTY::Prompt.new.ask('Database username')
    end

    def db_password
      @answers[:db_password] ||= TTY::Prompt.new.mask('Database password', echo: false)
    end

    def db_host
      @answers[:db_host] ||= TTY::Prompt.new.ask('Database host', default: '127.0.0.1')
    end

    def redis
      @answers[:redis] ||= TTY::Prompt.new.yes?('Using Redis?', default: true)
    end

    def redis_url
      @answers[:redis_url] ||= TTY::Prompt.new.ask('Redis URL', default: 'redis://127.0.0.1')
    end

    def redis_db
      @answers[:redis_db] ||= TTY::Prompt.new.ask('Redis DB (0-15)', default: '0') do |answer|
        answer.in('0-15')
      end
    end

    def redis_port
      @answers[:redis_port] ||= TTY::Prompt.new.ask('Redis PORT', default: '6379')
    end

    def sentinel
      @answers[:sentinel] ||= TTY::Prompt.new.yes?('Using Redis Sentinel for production?', default: false)
    end

    def sentinel_url
      @answers[:sentinel_url] ||= TTY::Prompt.new.ask('Redis Sentinel production URL', default: 'redis://sentinel-master')
    end

    def sentinel_db
      @answers[:sentinel_db] ||= TTY::Prompt.new.ask('Redis Sentinel DB (0-15)', default: '0') do |answer|
        answer.in('0-15')
      end
    end

    def sentinel_port
      @answers[:sentinel_port] ||= TTY::Prompt.new.ask('Redis Sentinel production PORT', default: '26379')
    end

    def sentinel_hosts
      @answers[:sentinel_hosts] ||= TTY::Prompt.new.ask('Enter space separated Sentinel slaves host names') do |answer|
        answer.default('sentinel-slave-1 sentinel-slave-2 sentinel-slave-3')
      end
    end

    def sidekiq
      @answers[:sidekiq] ||= TTY::Prompt.new.yes?('Using Sidekiq?', default: true)
    end

    def sidekiq_namespace
      @answers[:sidekiq_namespace] ||= TTY::Prompt.new.ask('Enter Sidekiq nampespace', default: 'sidekiq')
    end

    def git
      return false if no_git?

      @answers[:git] ||= TTY::Prompt.new.yes?('Setup git version control?', default: true)
    end

    def git_remote
      @answers[:git_remote] ||= TTY::Prompt.new.ask('Git remote address (HTTPS/SSH)', required: true)
    end

    def git_credentials
      @answers[:git_credentials] ||= TTY::Prompt.new.yes?(
        'Setup git credentials specific for this repository? If not, globals are used.',
        default: false
      )
    end

    def git_username
      @answers[:git_username] ||= TTY::Prompt.new.ask('Git username', default: ENV['USER'])
    end

    def git_email
      @answers[:git_email] ||= TTY::Prompt.new.ask('Git email', required: true)
    end

    def git_branching_model
      @answers[:git_branching_model] ||= TTY::Prompt.new.select(
        'Select git branching model',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        menu.help('none by default')
        menu.default(3)
        menu.per_page(OPTS[:git_branching_model].length)
        OPTS[:git_branching_model].each { |opt| menu.choice(opt) }
      end
    end

    def custom?
      @answers[:type] == :custom
    end

    def db_sqlite?
      @answers[:db_provider] == :sqlite
    end

    def rubocop?
      @answers[:dev].any? { |g| g[:value] == :rubocop }
    end

    private

    def prd_defaults
      defaults = (1..OPTS[:prd].length).to_a
      flat = OPTS[:prd].map { |hash| hash[:value] }
      defaults.delete(flat.index(:action_mailer) + 1) if no_action_mailer?
      defaults.delete(flat.index(:action_cable) + 1) if no_action_cable?
      defaults.delete(flat.index(:active_job) + 1) if no_active_job?
      defaults.delete(flat.index(:active_storage) + 1) if no_active_storage?
      defaults
    end

    def dev_defaults
      defaults = (1..OPTS[:dev].length).to_a
      flat = OPTS[:dev].map { |hash| hash[:value] }
      defaults.delete(flat.index(:spring) + 1) if no_spring?
      defaults
    end
  end
end
