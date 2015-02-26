require 'sidekiq/web'
require 'sidekiq-cron'

run Rack::URLMap.new('/sidekiq' => Sidekiq::Web)
