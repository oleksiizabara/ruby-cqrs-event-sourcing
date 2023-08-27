require 'event_store/store'

EventStore::Store.configure do |config|
  config.channels = %w[game user telegram telegram_profile player room team chat]
  config.redis_url = ENV['REDIS_URL']
end

EventStore::Store.listen
