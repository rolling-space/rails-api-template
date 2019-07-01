# frozen_string_literal: true

Sidekiq.remove_delay!

if Rails.env.test? || Rails.env.development? # rat-sentinel
  defaults = {
    url: ENV['REDIS_URL'],
    db: ENV['REDIS_DB'],
    namespace: ENV['SIDEKIQ_NAMESPACE']
  }
else # rat-sentinel
  SENTINELS = ENV['SENTINEL_HOSTS'].split(' ').map! do |host| # rat-sentinel
    { host: host, port: ENV['SENTINEL_PORT'] } # rat-sentinel
  end # rat-sentinel
 # rat-sentinel
  defaults = { # rat-sentinel
    url: ENV['SENTINEL_URL'], # rat-sentinel
    sentinels: SENTINELS, # rat-sentinel
    role: :master, # rat-sentinel
    namespace: ENV['SIDEKIQ_NAMESPACE'] # rat-sentinel
  } # rat-sentinel
end # rat-sentinel

Sidekiq.configure_server do |config|
  config.redis = defaults.merge(size: 50)
end

Sidekiq.configure_client do |config|
  config.redis = defaults.merge(size: 10)
end
