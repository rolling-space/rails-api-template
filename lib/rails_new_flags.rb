# frozen_string_literal: true

module Template
  module RailsNewFlags
    def no_action_mailer?
      @flags.include?('-M') || @flags.include?('--skip-action-mailer') || @flags.include?('--skip-action-mailbox')
    end

    def no_action_cable?
      @flags.include?('-C') || @flags.include?('--skip-action-cable')
    end

    def no_active_storage?
      @flags.include?('--skip-active-storage')
    end

    def no_active_job?
      @flags.include?('--skip-active-job')
    end

    def no_git?
      @flags.include?('-G') || @flags.include?('--skip-git') 
    end

    def no_spring?
      @flags.include?('--skip-spring') 
    end

    def db_flag?
      @flags.include?('-d') || @flags.include?('--database')
    end

    def db_provider_flag
      return :mysql if @flags.include?('mysql')
      return :pgsql if @flags.include?('postgresql')
    end
  end
end
