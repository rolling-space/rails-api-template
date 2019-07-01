# frozen_string_literal: true

if %i[test development].include?(Rails.env.to_sym) # rat-sentinel
  Redis.current = Redis.new(url: ENV['REDIS_URL'],
                            port: ENV['REDIS_PORT'],
                            db: ENV['REDIS_DB'])
else # rat-sentinel
  SENTINELS = ENV['SENTINEL_HOSTS'].split(' ').map! do |host| # rat-sentinel
    { host: host, port: ENV['SENTINEL_PORT'] } # rat-sentinel
  end # rat-sentinel
 # rat-sentinel
  Redis.current = Redis.new(url: ENV['SENTINEL_URL'], # rat-sentinel
                            sentinels: SENTINELS, # rat-sentinel
                            role: :master) # rat-sentinel
end # rat-sentinel
