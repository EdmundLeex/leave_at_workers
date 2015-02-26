# encoding: UTF-8

require 'require_all'
require 'sidekiq'

require_all 'models', 'workers', 'lib', 'extensions'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { :size => 5 }
end
