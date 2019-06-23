# frozen_string_literal: true

require 'tty-prompt'

module Template
  class Ask
    include Template::Defaults

    attr_reader :answers

    def initialize(active_color = :bright_yellow)
      @active_color = active_color
      @answers = {}
    end
        
    def installation_type
      @answers[:installation_type] = TTY::Prompt.new.select(
        'Installation type',
        OPTS[:types],
        echo: false,
        cycle: true,
        per_page: OPTS[:types].length,
        active_color: @active_color
      )
    end

    def prd
      @answers[:prd] = TTY::Prompt.new.multi_select(
        'Production gems',
        echo: false,
        cycle: true,
        active_color: @active_color,
      ) do |menu|
        menu.help('all by default')
        menu.default(*(1..OPTS[:prd].length).to_a)
        menu.per_page(OPTS[:prd].length)
        OPTS[:prd].each { |opt| menu.choice(opt) }
      end
    end

    def sidekiq
      @answers[:sidekiq] = TTY::Prompt.new.yes?(
        'Sidekiq?',
        active_color: @active_color
      )
    end

    def dev
      @answers[:dev] = TTY::Prompt.new.multi_select(
        'Development gems',
        echo: false,
        cycle: true,
        active_color: @active_color
      ) do |menu|
        menu.help('all by default')
        menu.default(*(1..OPTS[:dev].length).to_a)
        menu.per_page(OPTS[:dev].length)
        OPTS[:dev].each { |opt| menu.choice(opt) }
      end
    end


    def tst
      @answers[:tst] = TTY::Prompt.new.multi_select(
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

    def deploy
      @answers[:deploy] = TTY::Prompt.new.yes?(
        'Capistrano?',
        active_color: @active_color
      )
    end

    def ci
      @answers[:deploy] = TTY::Prompt.new.select(
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
  end
end
