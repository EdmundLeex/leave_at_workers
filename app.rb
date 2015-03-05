# encoding: UTF-8
require 'sinatra/activerecord'
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end
Sidekiq.configure_server do |config|
  config.redis = { :size => 1 }
end

require 'require_all'
require_all 'workers', 'lib', 'extensions'
